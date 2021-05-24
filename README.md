![LgTvWebOSSwift Banner](https://user-images.githubusercontent.com/70895232/119380019-dbad9780-bcc8-11eb-99e1-1264a9f6a0e8.png)
# LgTvWebOSSwift

### Oneliner here

## Motivation

## How to Install

## How to Use

### Note: 
This package requires you to manually input the LG TV’s IP.
If you want to discover devices on the network I recommend using the [SSDPClient package](https://github.com/pierrickrouxel/SSDPClient)

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
