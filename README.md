![LgTvWebOSSwift Banner](https://user-images.githubusercontent.com/70895232/119380019-dbad9780-bcc8-11eb-99e1-1264a9f6a0e8.png)
# LgTvWebOSSwift

 LgTvWebOSSwift is a Swift library that allows you to simply and easily send commands from an iOS device to an LG Smart TV running WebOS.

## Motivation

I'm a co-founder at [Magico](https://www.magico.ai/). We're building an app that allows users to control their TV with simple hand gestures via the Apple Watch.
So this is pretty straight forwared - I neeeded a way to send commands to an LG Smart TV via an iPhone.


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
    lg.delegate = self
    
    // and use this delegate method to save the token you recieve
    
    func lgtvDidConnect(with token: String) {
        *SAVE THE TOKEN*
    }
    
    // If you already have a token you can use it so there's no popup on the TV:
    
    let lg = LgTvWebOSSwift(url: *YOUR DEVICE URL*, token: *YOUR SAVED TOKEN*)
    lg.delegate = self
    
}

```

After the connection has been established you can use the following commands:

```swift

lg.senKey(.up)                              //Send an "UP" arrow button key press.
lg.senKey(.down)                            //Send an "DOWN" arrow button key press.
lg.senKey(.left)                            //Send an "LEFT" arrow button key press.
lg.senKey(.right)                           //Send an "RIGHT" arrow button key press.
lg.senKey(.home)                            //Send an "HOME" button key press.
lg.senKey(.enter)                           //Send an "ENTER" / "SELECT" button key press.
lg.senKey(.back)                            //Send an "BACK" / "RETURN" arrow button key press.
lg.senKey(.volumeUp)                        //Send an "VOLUME UP" button key press.
lg.senKey(.volumeDown)                      //Send an "VOLUME DOWN" button key press.
lg.senKey(.mute)                            //Send an "MUTE" button key press.

```



## Credits
In the making of LgTvWebOSSwift I've relied heavily on the following libraries:

1. [PyWebOSTV (Python)](https://github.com/supersaiyanmode/PyWebOSTV)
2. [lgtv2 (JavaScript)](https://github.com/hobbyquaker/lgtv2)

## Dependencies:
1. [Starscream WebSockets Client](https://github.com/daltoniam/Starscream)
2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## To Do
- [ ] Add install instructions.
- [ ] Add more commands.
- [ ] Add support for all types of commands (non-mouse input) .
- [ ] Seperate the use of mouse input to be non default.
- [ ] Add tests.
- [ ] Add package to CocoaPods.
