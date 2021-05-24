# LgTvWebOSSwift

### Oneliner here

## Motivation

## How to Install

## How to Use

### Note: 
This package requires you to manually input the LG TV’s IP.
If you want to discover devices on the network I can recommend the SSDPClient package: https://github.com/pierrickrouxel/SSDPClient

### Setup

```swift

import LgTvWebOSSwift

class SomeClass: LgTvWebOSSwiftDelegate {
    
    // If this is the first you connect to this TV (a popup will appear in the TV and require user authorization):
    
    let lg = LgTvWebOSSwift(url: *YOUR DEVICE URL*)
    
    // and use this delegate method to save the token you recieve
    
    func lgtvDidConnect(with token: String) {
        *SAVE THE TOKEN*
    }
    
    // If you already have a token you can use it so there's no popup on the TV:
    
    let lg = LgTvWebOSSwift(url: *YOUR DEVICE URL*, token: *YOUR SAVED TOKEN*)

    
}

```
