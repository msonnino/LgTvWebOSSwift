import Foundation
import Starscream
import SwiftyJSON

public class LgTvWebOSSwift: WebSocketDelegate  {
    
    private let serialQueue: DispatchQueue = DispatchQueue(label:"LgTvWebOSSwift")

    private(set) var url: String
    private(set) var token: String?
    
    private var isConnected:Bool = false
    private var isConnecting:Bool = false
    
    private var socket:WebSocket?
    private var mouseSocket: LgMouse?
    
    var delegate: LgTvWebOSSwiftDelegate?
    
    public init(url: String, token: String?) {
        //Make sure you provide the device's URL as pure digits (i.e xxx.xxx.xx.xx, no "http://", etc...)
        self.url = "wss://" + url + ":3001"
        if token != nil {
            self.token = token
        }
    }
    
    deinit {
        self.disconnect()
    }
   
    //MARK: - Connection
    
    func connect() {
        
        self.serialQueue.async {
                        
            if self.isConnected || self.isConnecting {
                
                return
            }
            
            if let sock = self.initSocket(self.url) {
                
                self.isConnecting = true
                print("LgTvWebOSSwift: Socket trying to connect")

                sock.connect()
                
            }
        }
        
    }
    
    private func initSocket(_ uri:String) -> WebSocket? {
                
        let deviceUrl = url
        
        if let requestUrl = URL(string: deviceUrl)
        {
            var request = URLRequest(url: requestUrl)
            request.timeoutInterval = 15

            self.socket = WebSocket(request: request, certPinner: nil)
            self.socket!.delegate = self
            self.socket?.respondToPingWithPong = true
            return self.socket
        }
        
        return nil
    }
    
    
    func disconnect() {
        
        self.serialQueue.async {
        
            if let sock = self.socket {
                sock.forceDisconnect()
            }
            if let mouseSock = self.mouseSocket {
                mouseSock.disconnect()
            }
            
            self.isConnected = false
            self.isConnecting = false
            self.cleanSocket()
        }
    }
    
    private func cleanSocket() {
        
        if let sock = self.socket {
            sock.delegate = nil
            self.socket = nil
        }
        if let mouseSock = self.mouseSocket {
            mouseSock.disconnect()
            self.mouseSocket = nil
        }
    }
    
    func connectionState() -> Bool {
        if mouseSocket != nil {
            return mouseSocket!.connectionState()
        } else {
            return false
        }
    }
    
    //MARK: - Handshake and Token
    
    private func socketSendHandshake() {
        //This handshake is sent as-is since we don't really know how to change it and changing it defects the functionality.
        let handshake: String
        
        if token != nil {
            handshake =  "{\"type\":\"register\",\"id\":\"register_0\",\"payload\":{\"forcePairing\":false,\"pairingType\":\"PROMPT\",\"client-key\":\"\(token!)\",\"manifest\":{\"manifestVersion\":1,\"appVersion\":\"1.1\",\"signed\":{\"created\":\"20140509\",\"appId\":\"com.lge.test\",\"vendorId\":\"com.lge\",\"localizedAppNames\":{\"\":\"LG Remote App\",\"ko-KR\":\"리모컨 앱\",\"zxx-XX\":\"ЛГ Rэмotэ AПП\"},\"localizedVendorNames\":{\"\":\"LG Electronics\"},\"permissions\":[\"TEST_SECURE\",\"CONTROL_INPUT_TEXT\",\"CONTROL_MOUSE_AND_KEYBOARD\",\"READ_INSTALLED_APPS\",\"READ_LGE_SDX\",\"READ_NOTIFICATIONS\",\"SEARCH\",\"WRITE_SETTINGS\",\"WRITE_NOTIFICATION_ALERT\",\"CONTROL_POWER\",\"READ_CURRENT_CHANNEL\",\"READ_RUNNING_APPS\",\"READ_UPDATE_INFO\",\"UPDATE_FROM_REMOTE_APP\",\"READ_LGE_TV_INPUT_EVENTS\",\"READ_TV_CURRENT_TIME\"],\"serial\":\"2f930e2d2cfe083771f68e4fe7bb07\"},\"permissions\":[\"LAUNCH\",\"LAUNCH_WEBAPP\",\"APP_TO_APP\",\"CLOSE\",\"TEST_OPEN\",\"TEST_PROTECTED\",\"CONTROL_AUDIO\",\"CONTROL_DISPLAY\",\"CONTROL_INPUT_JOYSTICK\",\"CONTROL_INPUT_MEDIA_RECORDING\",\"CONTROL_INPUT_MEDIA_PLAYBACK\",\"CONTROL_INPUT_TV\",\"CONTROL_POWER\",\"READ_APP_STATUS\",\"READ_CURRENT_CHANNEL\",\"READ_INPUT_DEVICE_LIST\",\"READ_NETWORK_STATE\",\"READ_RUNNING_APPS\",\"READ_TV_CHANNEL_LIST\",\"WRITE_NOTIFICATION_TOAST\",\"READ_POWER_STATE\",\"READ_COUNTRY_INFO\"],\"signatures\":[{\"signatureVersion\":1,\"signature\":\"eyJhbGdvcml0aG0iOiJSU0EtU0hBMjU2Iiwia2V5SWQiOiJ0ZXN0LXNpZ25pbmctY2VydCIsInNpZ25hdHVyZVZlcnNpb24iOjF9.hrVRgjCwXVvE2OOSpDZ58hR+59aFNwYDyjQgKk3auukd7pcegmE2CzPCa0bJ0ZsRAcKkCTJrWo5iDzNhMBWRyaMOv5zWSrthlf7G128qvIlpMT0YNY+n/FaOHE73uLrS/g7swl3/qH/BGFG2Hu4RlL48eb3lLKqTt2xKHdCs6Cd4RMfJPYnzgvI4BNrFUKsjkcu+WD4OO2A27Pq1n50cMchmcaXadJhGrOqH5YmHdOCj5NSHzJYrsW0HPlpuAx/ECMeIZYDh6RMqaFM2DXzdKX9NmmyqzJ3o/0lkk/N97gfVRLW5hA29yeAwaCViZNCP8iC9aO0q9fQojoa7NQnAtw==\"}]}}}"
        } else {
            handshake = "{\"type\":\"register\",\"id\":\"register_0\",\"payload\":{\"forcePairing\":false,\"pairingType\":\"PROMPT\",\"manifest\":{\"manifestVersion\":1,\"appVersion\":\"1.1\",\"signed\":{\"created\":\"20140509\",\"appId\":\"com.lge.test\",\"vendorId\":\"com.lge\",\"localizedAppNames\":{\"\":\"LG Remote App\",\"ko-KR\":\"리모컨 앱\",\"zxx-XX\":\"ЛГ Rэмotэ AПП\"},\"localizedVendorNames\":{\"\":\"LG Electronics\"},\"permissions\":[\"TEST_SECURE\",\"CONTROL_INPUT_TEXT\",\"CONTROL_MOUSE_AND_KEYBOARD\",\"READ_INSTALLED_APPS\",\"READ_LGE_SDX\",\"READ_NOTIFICATIONS\",\"SEARCH\",\"WRITE_SETTINGS\",\"WRITE_NOTIFICATION_ALERT\",\"CONTROL_POWER\",\"READ_CURRENT_CHANNEL\",\"READ_RUNNING_APPS\",\"READ_UPDATE_INFO\",\"UPDATE_FROM_REMOTE_APP\",\"READ_LGE_TV_INPUT_EVENTS\",\"READ_TV_CURRENT_TIME\"],\"serial\":\"2f930e2d2cfe083771f68e4fe7bb07\"},\"permissions\":[\"LAUNCH\",\"LAUNCH_WEBAPP\",\"APP_TO_APP\",\"CLOSE\",\"TEST_OPEN\",\"TEST_PROTECTED\",\"CONTROL_AUDIO\",\"CONTROL_DISPLAY\",\"CONTROL_INPUT_JOYSTICK\",\"CONTROL_INPUT_MEDIA_RECORDING\",\"CONTROL_INPUT_MEDIA_PLAYBACK\",\"CONTROL_INPUT_TV\",\"CONTROL_POWER\",\"READ_APP_STATUS\",\"READ_CURRENT_CHANNEL\",\"READ_INPUT_DEVICE_LIST\",\"READ_NETWORK_STATE\",\"READ_RUNNING_APPS\",\"READ_TV_CHANNEL_LIST\",\"WRITE_NOTIFICATION_TOAST\",\"READ_POWER_STATE\",\"READ_COUNTRY_INFO\"],\"signatures\":[{\"signatureVersion\":1,\"signature\":\"eyJhbGdvcml0aG0iOiJSU0EtU0hBMjU2Iiwia2V5SWQiOiJ0ZXN0LXNpZ25pbmctY2VydCIsInNpZ25hdHVyZVZlcnNpb24iOjF9.hrVRgjCwXVvE2OOSpDZ58hR+59aFNwYDyjQgKk3auukd7pcegmE2CzPCa0bJ0ZsRAcKkCTJrWo5iDzNhMBWRyaMOv5zWSrthlf7G128qvIlpMT0YNY+n/FaOHE73uLrS/g7swl3/qH/BGFG2Hu4RlL48eb3lLKqTt2xKHdCs6Cd4RMfJPYnzgvI4BNrFUKsjkcu+WD4OO2A27Pq1n50cMchmcaXadJhGrOqH5YmHdOCj5NSHzJYrsW0HPlpuAx/ECMeIZYDh6RMqaFM2DXzdKX9NmmyqzJ3o/0lkk/N97gfVRLW5hA29yeAwaCViZNCP8iC9aO0q9fQojoa7NQnAtw==\"}]}}}"
        }
        
        if let sock = self.socket {
            sock.write(string: handshake)
        }
        
    }
    
    // Gets the token that was sent by the TV.
    private func getTokenFromJson (_ string: String) -> String? {
        
        let json = JSON.init(parseJSON: string)
        if let token = JSON(json)["payload"]["client-key"].string {
            return token
        } else {
            print("Error getting client-key (token)")
        }
        
        return nil

    }
    
    //MARK: - Send Commands
    
    func sendKey(_ key: TvKey) {
        
        self.serialQueue.async {
        
            if self.isConnected == false {
                print("Lg TV key send failed. reason  = TV is disconnected.")
                return
            }
            
            var keyString: String
            
            switch key {
            case .up:
                keyString = "UP"
            case .down:
                keyString = "DOWN"
            case .left:
                keyString = "LEFT"
            case .right:
                keyString = "RIGHT"
            case .home:
                keyString = "HOME"
            case .enter:
                keyString = "ENTER"
            case .back:
                keyString = "BACK"
            case .volumeUp:
                keyString = "VOLUMEUP"
            case .volumeDown:
                keyString = "VOLUMEDOWN"
            case .mute:
                keyString = "MUTE"
            }
            //Keys are sent thorugh a secondery Input Socket (mouseSocket)
            if let mouseSock = self.mouseSocket {
                mouseSock.sendKey(keyString)
            }
            
        }
    }

    
    
    //MARK:- Socket Events Handlers
    
    public func didReceive (event: WebSocketEvent, client: WebSocket) {
        
        self.socketEventsHandler(event: event, client: client)
    }
    
    private func socketEventsHandler (event: WebSocketEvent, client: WebSocket) {
        
        self.serialQueue.async {
            
            switch event {
                
            case .connected(let headers):
                print("LgTvWebOSSwift:socketEventsHandler connected = \(headers)")
                self.socketSendHandshake()
                break
                
            case .disconnected(let reason, let code):
                self.isConnected = false
                self.isConnecting = false
                print("LgTvWebOSSwift:socketEventsHandler disconnected. reason = \(reason) code = \(code)")
                break
                
            case .text(let string):
                if let token = self.getTokenFromJson(string) {
                    self.token = token
                    
                    // Make sure you persist the token so you can use it next time and connect without a TV prompt.
                    self.delegate?.lgtvDidConnect(with: token)
                }
                self.isConnected = true
                self.isConnecting = false
                print("LgTvWebOSSwift:socketEventsHandler text = \(string)")
                
                //We check that the pairing (registration) was completed and we ask for the mouse socket's path
                let JsonResponse = JSON.init(parseJSON: string)
                if JsonResponse["type"] == "registered" {
                    self.getMouseSocketPath()
                }
                
                // We check that we've recieved the mouse socket path from the TV and we connect it.
                if let mouseSocketPath = JsonResponse["payload"]["socketPath"].string {
                    print(mouseSocketPath)
                    self.connectMouseSocket(mouseSocketPath)
                }
                
                break
                
            case .ping(_):
                break
                
            case .pong(_):
                break
                
            case .viabilityChanged(_):
                print("LgTvWebOSSwift:socketEventsHandler viabilityChanged")
                break
                
            case .reconnectSuggested(_):
                print("LgTvWebOSSwift:socketEventsHandler reconnectSuggested")
                break
                
            case .cancelled:
                print("LgTvWebOSSwift:socketEventsHandler cancelled")
                self.isConnected = false
                self.isConnecting = false
                break
                
            case .error(let error):
                print("LgTvWebOSSwift:socketEventsHandler error = \(error!)")
                self.isConnected = false
                self.isConnecting = false
                break
                
            default:
                print("LgTvWebOSSwift:socketEventsHandler default handler = \(event)")
                break
            }
        }
    }
    
    
    //MARK: - Mouse Socket Methods
    
    //This methods gets the websocket path for input controls
    func getMouseSocketPath() {
        let string = "{\"type\":\"request\", \"uri\": \"ssap://com.webos.service.networkinput/getPointerInputSocket\"}"
        
        if let sock = self.socket {
            sock.write(string: string)
        }
    }
    
    private func connectMouseSocket(_ uri:String) {
        mouseSocket = LgMouse(with: uri)
        mouseSocket?.connect()
    }
    
}
