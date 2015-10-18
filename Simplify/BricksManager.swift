//
//  BricksManager.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class BricksManager: NSObject {
    
    class func getConstantBricks() -> [ConstantBrick] {
        let brick1 = ConstantBrick()
        brick1.label1Text = "Constant "
        brick1.button1Text = "1"
        let brick2 = ConstantBrick()
        brick2.label1Text = "Constant "
        brick2.button1Text = "1.0"
        let brick3 = ConstantBrick()
        brick3.label1Text = "Constant "
        brick3.button1Text = "String"
        return [brick1, brick2, brick3]
    }
    
    class func getExpressionBricks() -> [ExpressionBrick] {
        let brick1 = ExpressionBrick()
        brick1.label1Text = ""
        brick1.button1Text = "10"
        brick1.label2Text = "+"
        brick1.button2Text = "10"
        let brick2 = ExpressionBrick()
        brick2.label1Text = ""
        brick2.button1Text = "10"
        brick2.label2Text = "-"
        brick2.button2Text = "10"
        let brick3 = ExpressionBrick()
        brick3.label1Text = ""
        brick3.button1Text = "10"
        brick3.label2Text = "*"
        brick3.button2Text = "10"
        let brick4 = ExpressionBrick()
        brick4.label1Text = ""
        brick4.button1Text = "10"
        brick4.label2Text = "/"
        brick4.button2Text = "10"
        let brick5 = ExpressionBrick()
        brick5.label1Text = ""
        brick5.button1Text = "10"
        brick5.label2Text = ">"
        brick5.button2Text = "10"
        let brick6 = ExpressionBrick()
        brick6.label1Text = ""
        brick6.button1Text = "10"
        brick6.label2Text = "<"
        brick6.button2Text = "10"
        let brick7 = ExpressionBrick()
        brick7.label1Text = ""
        brick7.button1Text = "10"
        brick7.label2Text = ">="
        brick7.button2Text = "10"
        let brick8 = ExpressionBrick()
        brick8.label1Text = ""
        brick8.button1Text = "10"
        brick8.label2Text = "<="
        brick8.button2Text = "10"
        let brick9 = ExpressionBrick()
        brick9.label1Text = ""
        brick9.button1Text = "10"
        brick9.label2Text = "="
        brick9.button2Text = "10"
        let brick10 = ExpressionBrick()
        brick10.label1Text = ""
        brick10.button1Text = "10"
        brick10.label2Text = "!="
        brick10.button2Text = "10"
        return [brick1, brick2, brick3, brick4, brick5, brick6, brick7, brick8, brick9, brick10]
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
        brick1.label1Text = "Data1"
        brick1.button1Text = "5"
        brick1.label2Text = "Data2"
        brick1.button2Text = "LightSensor"
        let brick2 = IFTTTBrick()
        brick2.label1Text = "Data1"
        brick2.button1Text = "MotionSensor"
        brick2.label2Text = "Data2"
        brick2.button2Text = "10"
        return [brick1, brick2]
    }
    
}
