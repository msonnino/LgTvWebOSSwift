//
//  File.swift
//  
//
//  Created by Michael Sonnino on 24/05/2021.
//


import Foundation
import Starscream
import SwiftyJSON

class LgMouse: WebSocketDelegate {
        
    // Serial queue by default
    private let serialQueue: DispatchQueue = DispatchQueue(label:"LgMouse")
    private var socket:WebSocket?
    
    private var isConnected:Bool = false
    private var isConnecting:Bool = false
    
    private var isInKeepingAliveConnection:Bool = false
    private var uri: String
    
    init(with url: String) {
        uri = url
    }
    
    deinit {
        self.disconnect()
    }
    
    func connect() {
        self.prvConnect()
    }
    
    private func prvConnect() {
        
        self.serialQueue.async {
            
            self.isInKeepingAliveConnection = false
            
            if self.isConnected || self.isConnecting {
                
                return
            }
            
            if let sock = self.initSocket() {
                
                self.isConnecting = true
                
                sock.connect()
                
            }
        }
    }
    
    
    func disconnect() {
//        self.prvDisconnect()
    }
    
    func connectionState () -> Bool {
        
        self.serialQueue.sync {
            return self.isConnected
        }
    }
    
    private func prvDisconnect() {
        
        self.serialQueue.async {
        
            if let sock = self.socket {
                sock.forceDisconnect()
            }
            
            self.isConnected = false
            self.isConnecting = false
            self.cleanSocket()
        }
    }
    
    private func initSocket(_ forceInit:Bool = false) -> WebSocket? {
                
//        let deviceUrl = self.getUrl(uri)
        
        if let requestUrl = URL(string: uri)
        {
            var request = URLRequest(url: requestUrl)
            request.timeoutInterval = 15
            let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates

            self.socket = WebSocket(request: request, certPinner: pinner)
            self.socket!.delegate = self
            self.socket?.respondToPingWithPong = true
            return self.socket
        }
        
        return nil
    }
    
    
    private func cleanSocket() {
        
        if let sock = self.socket {
            sock.delegate = nil
            self.socket = nil
        }
    }
    
    func reconnect (_ uri: String) {
    
        self.disconnect()
        self.connect()
    }
    
    
    func sendKey(_ key: String) {
        self.serialQueue.async {
        
            if self.isConnected == false {
                print("LgMouseSocket TV key send failed. reason  = TV is disconnected.")
                return
            }
            
            let keyByteData = self.getKeyByte(key)
            print("converted key to byte")
            if let sock = self.socket {
                sock.write(data: keyByteData) {
                    print("LgMouseSocket:sendKey. mouseSocket sent = \(key)")
                }
            } else {
                print("LgDevice:sendKey. Error = mouseSocket is nil")
            }
            
        }
    }
    
    private func getKeyByte (_ key: String) -> Data {
        let keyByteString = "type:button\nname:\(key)\n\n"
        let keyBytesArray = [UInt8](keyByteString.utf8)
        return Data(keyBytesArray)
    }
    
    //MARK:- Sockets Events Handlers
    
    func didReceive (event: WebSocketEvent, client: WebSocket) {
        
        self.socketEventsHandler(event: event, client: client)
    }
    
    private func socketEventsHandler (event: WebSocketEvent, client: WebSocket) {
        
        self.serialQueue.async {
            
            switch event {
                
            case .connected(let headers):
                self.isConnected = true
                print("LgMouseSocket:socketEventsHandler connected = \(headers)")
    
                break
                
            case .disconnected(let reason, let code):
                self.isConnected = false
                self.isConnecting = false
                print("LgMouseSocket:socketEventsHandler disconnected. reason = \(reason) code = \(code)")

                break
                
            case .text(let string):
                self.isConnected = true
                self.isConnecting = false
                print("LgMouseSocket:socketEventsHandler text = \(string)")

                break
                
            case .ping(_):
                break
                
            case .pong(_):
                break
                
            case .viabilityChanged(_):
                print("LgMouseSocket:socketEventsHandler viabilityChanged")
                break
                
            case .reconnectSuggested(_):
                print("LgMouseSocket:socketEventsHandler reconnectSuggested")
                break
                
            case .cancelled:
                print("LgMouseSocket:socketEventsHandler cancelled")
                self.isConnected = false
                self.isConnecting = false
                break
                
            case .error(let error):
                print("LgMouseSocket:socketEventsHandler error = \(error!)")
                self.isConnected = false
                self.isConnecting = false
                break
                
            default:
                print("LgMouseSocket:socketEventsHandler default handler = \(event)")
                break
            }
        }
    }
    
    
}


