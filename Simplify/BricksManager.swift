//
//  BricksManager.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class BricksManager: NSObject {
    
    class func getLEDBricks() -> [LEDBrick] {
        let brick1 = LEDBrick()
        brick1.label1Text = "Set Red LED"
        brick1.button1Text = "1"
        let brick2 = LEDBrick()
        brick2.label1Text = "Set Green LED"
        brick2.button1Text = "1"
        let brick3 = LEDBrick()
        brick3.label1Text = "Set Blue LED"
        brick3.button1Text = "1"
        let brick4 = LEDBrick()
        brick4.label1Text = "Blink Red LED"
        brick4.button1Text = "1"
        brick4.label2Text = "sec"
        brick4.button2Text = "2"
        brick4.label3Text = "blinks"
        let brick5 = LEDBrick()
        brick5.label1Text = "Blink Green LED"
        brick5.button1Text = "1"
        brick5.label2Text = "sec"
        brick5.button2Text = "2"
        brick5.label3Text = "blinks"
        let brick6 = LEDBrick()
        brick6.label1Text = "Blink Blue LED"
        brick6.button1Text = "1"
        brick6.label2Text = "sec"
        brick6.button2Text = "2"
        brick6.label3Text = "blinks"
        let brick7 = LEDBrick()
        brick7.label1Text = "Set RGBLED"
        brick7.button1Text = "244,244,244"
        return [brick1, brick2, brick3, brick4, brick5, brick6, brick7]
    }
    
    class func getDevicesBricks() -> [DevicesBrick] {
        let brick1 = DevicesBrick()
        brick1.label1Text = "Wait Button Press"
        let brick2 = DevicesBrick()
        brick2.label1Text = "Set Servo Angle"
        brick2.button1Text = "180"
        let brick3 = DevicesBrick()
        brick3.label1Text = "Step Servo Angle"
        brick3.button1Text = "180"
        return [brick1, brick2, brick3]
    }
    
    class func getIfBricks() -> [IfBrick] {
        let brick5 = IfBrick()
        brick5.label1Text = "If"
        brick5.button1Text = "10"
        brick5.label2Text = ">"
        brick5.button2Text = "10"
        let brick6 = IfBrick()
        brick6.label1Text = "If"
        brick6.button1Text = "10"
        brick6.label2Text = "<"
        brick6.button2Text = "10"
        let brick7 = IfBrick()
        brick7.label1Text = "If"
        brick7.button1Text = "10"
        brick7.label2Text = ">="
        brick7.button2Text = "10"
        let brick8 = IfBrick()
        brick8.label1Text = "If"
        brick8.button1Text = "10"
        brick8.label2Text = "<="
        brick8.button2Text = "10"
        let brick9 = IfBrick()
        brick9.label1Text = "If"
        brick9.button1Text = "10"
        brick9.label2Text = "="
        brick9.button2Text = "10"
        let brick10 = IfBrick()
        brick10.label1Text = "If"
        brick10.button1Text = "10"
        brick10.label2Text = "!="
        brick10.button2Text = "10"
        return [brick5, brick6, brick7, brick8, brick9, brick10]
    }
    
    class func getRepeatForBricks() -> [RepeatForBrick] {
        let brick1 = RepeatForBrick()
        brick1.label1Text = "Repeat for"
        brick1.button1Text = "3"
        brick1.label2Text = "Times"
        return [brick1]
    }
    
    class func getRepeatUntilBricks() -> [RepeatUntilBrick] {
        let brick5 = RepeatUntilBrick()
        brick5.label1Text = "Repeat Until"
        brick5.button1Text = "10"
        brick5.label2Text = ">"
        brick5.button2Text = "10"
        let brick6 = RepeatUntilBrick()
        brick6.label1Text = "Repeat Until"
        brick6.button1Text = "10"
        brick6.label2Text = "<"
        brick6.button2Text = "10"
        let brick7 = RepeatUntilBrick()
        brick7.label1Text = "Repeat Until"
        brick7.button1Text = "10"
        brick7.label2Text = ">="
        brick7.button2Text = "10"
        let brick8 = RepeatUntilBrick()
        brick8.label1Text = "Repeat Until"
        brick8.button1Text = "10"
        brick8.label2Text = "<="
        brick8.button2Text = "10"
        let brick9 = RepeatUntilBrick()
        brick9.label1Text = "Repeat Until"
        brick9.button1Text = "10"
        brick9.label2Text = "="
        brick9.button2Text = "10"
        let brick10 = RepeatUntilBrick()
        brick10.label1Text = "Repeat Until"
        brick10.button1Text = "10"
        brick10.label2Text = "!="
        brick10.button2Text = "10"
        return [brick5, brick6, brick7, brick8, brick9, brick10]
    }
    
    class func getSleepBricks() -> [SleepBrick] {
        let brick1 = SleepBrick()
        brick1.label1Text = "Sleep for"
        brick1.button1Text = "5"
        brick1.label2Text = "sec"
        return [brick1]
    }
    
    class func getIFTTTBricks() -> [IFTTTBrick] {
        let brick1 = IFTTTBrick()
        brick1.label1Text = "Get Weather"
        let brick2 = IFTTTBrick()
        brick2.label1Text = "Button Pressed"
        return [brick1, brick2]
    }
    
}
