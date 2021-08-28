//
//  File.swift
//  
//
//  Created by Michael Sonnino on 24/05/2021.
//

import Foundation

//MARK: - LgTvWebOSSwiftDelegate

public protocol LgTvWebOSSwiftDelegate {
    
    func lgtvDidConnect(with token: String)
    
}

//MARK: - StringProtocol Extension for Data

extension StringProtocol {
    var data: Data { .init(utf8) }
    var bytes: [UInt8] { .init(utf8) }
}

//MARK: - TvKey enum

enum TvKey {
    case up
    case down
    case left
    case right
    case home
    case enter
    case back
    case volumeUp
    case volumeDown
    case mute
}
