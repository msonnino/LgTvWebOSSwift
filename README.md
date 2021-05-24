![LgTvWebOSSwift Banner](https://user-images.githubusercontent.com/70895232/119380019-dbad9780-bcc8-11eb-99e1-1264a9f6a0e8.png)
# LgTvWebOSSwift

### LgTvWebOSSwift is a Swift library that allows you to simply and easily send commands from an iOS device to an LG smart TV running WebOS.

## Motivation

## How to Install

## How to Use

### Note: 

**In order for this package to work the iOS device running it and the LG TV must be connected to the same WiFi network.**

This package requires you to manually input the LG TV’s IP.

*If you want to discover devices on the network I recommend using the [SSDPClient package](https://github.com/pierrickrouxel/SSDPClient)*

### Setup

```swift

import LgTvWebOSSwift

class SomeClass: LgTvWebOSSwiftDelegate {
    
    // If this is the first you connect to this TV: (a popup will appear on the TV and require user authorization)
    
    let lg = LgTvWebOSSwift(url: *YOUR DEVICE URL*)
    
    // and use this delegate method to save the token you recieve
    
    func lgtvDidConnect(with token: String) {
        *SAVE THE TOKEN*
    }
    
    // If you already have a token you can use it so there's no popup on the TV:
    
    let lg = LgTvWebOSSwift(url: *YOUR DEVICE URL*, token: *YOUR SAVED TOKEN*)

    
}

```

## Credits
In the making of LgTvWebOSSwift I've relied heavily on the following libraries:

1. [PyWebOSTV (Python)](https://github.com/supersaiyanmode/PyWebOSTV)
2. [lgtv2 (JavaScript)](https://github.com/hobbyquaker/lgtv2)

## Dependencies:
1. [Starscream WebSockets Client](https://github.com/daltoniam/Starscream)
2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

