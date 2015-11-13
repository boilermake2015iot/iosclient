//
//  BricksManager.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class BricksManager: NSObject {
    
    class func getMessageBricks() -> [MessageBrick] {
        let brick1 = MessageBrick()
        brick1.label1Text = "It is "
        brick1.button1Text = "Current Temperature"
        brick1.label2Text = " C"
        let brick2 = MessageBrick()
        brick2.label1Text = "It is "
        brick2.button1Text = "Current Humidity"
        let brick3 = MessageBrick()
        brick3.label1Text = "pitch "
        brick3.button1Text = "Accelerometer value"
        let brick4 = MessageBrick()
        brick4.label1Text = "roll "
        brick4.button1Text = "Gyroscope value"
        let brick5 = MessageBrick()
        brick5.label1Text = "yaw "
        brick5.button1Text = "Gyroscope value"
        let brick6 = MessageBrick()
        brick6.label1Text = "north "
        brick6.button1Text = "Compass value"
        return [brick1, brick2, brick3, brick4, brick5, brick6]
    }
    
    class func getDevicesBricks() -> [DevicesBrick] {
        let brick1 = DevicesBrick()
        brick1.label1Text = "Rotate Screen - 0 degrees"
        let brick2 = DevicesBrick()
        brick2.label1Text = "Rotate Screen - 90 degrees"
        let brick3 = DevicesBrick()
        brick3.label1Text = "Rotate Screen - 180 degrees"
        let brick4 = DevicesBrick()
        brick4.label1Text = "Rotate Screen - 270 degrees"
        return [brick1, brick2, brick3, brick4]
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
//        let brick2 = IFTTTBrick()
//        brick2.label1Text = "Button Pressed"
        return [brick1]
    }
    
    class func getGridBricks() -> [GridBrick] {
        let brick1 = GridBrick()
        brick1.label1Text = "8 x 8"
        var array = [String]()
        for _ in 1...64 {
            array.append("0,0,0")
        }
        brick1.button1Text = array.joinWithSeparator(" | ")
        let brick2 = GridBrick()
        brick2.label1Text = "x "
        brick2.button1Text = "0"
        brick2.label2Text = " y "
        brick2.button2Text = "0"
        brick2.label3Text = " set "
        brick2.button3Text = "0,0,0"
        return [brick1, brick2]
    }
    
}
