//
//  JSONFactory.swift
//  Simplify
//
//  Created by George Lo on 10/18/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class JSONFactory: NSObject {
    
    class func getJSONStringForBricks(bricks: [Brick]) -> String {
        let jsonObj = self.generateJSONObject(bricks)
        let jsonString = JSONStringify(jsonObj)
        return jsonString
    }
    
    // MARK: Generate JSON
    
    class func generateJSONObject(bricks: [Brick]) -> NSMutableDictionary {
        var beginCount = 0
        let ret = NSMutableDictionary()
        let pages = NSMutableArray()
        let page = NSMutableDictionary()
        let nodes = NSMutableArray()
        for brick in bricks {
            let dict = NSMutableDictionary()
            if brick.type == .LED {
                if brick.label1Text == "Set Red LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("RedLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Set Green LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("GreenLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Set Blue LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("BlueLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Blink Red LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("RedLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Blink Green LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("GreenLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Blink Blue LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("BlueLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Set RGBLED" {
                    dict.setObject("SetRgbLed", forKey: "Type")
                    dict.setObject("RgbLed", forKey: "Device")
                    let rgb = brick.button1Text!.componentsSeparatedByString(",") as [String]
                    dict.setObject(self.generateDictForText(rgb[0]), forKey: "R")
                    dict.setObject(self.generateDictForText(rgb[1]), forKey: "G")
                    dict.setObject(self.generateDictForText(rgb[2]), forKey: "B")
                } else {
                    print("\"\(brick.label1Text)\"")
                }
            } else if brick.type == .Devices {
                if brick.label1Text == "Wait Button Press" {
                    dict.setObject("WaitButtonPress", forKey: "Type")
                    dict.setObject("Button", forKey: "Device")
                } else if brick.label1Text == "Set Servo Angle" {
                    dict.setObject("SetServoAngle", forKey: "Type")
                    dict.setObject("Servo", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Angle")
                } else if brick.label1Text == "Step Servo Angle" {
                    dict.setObject("StepServoAngle", forKey: "Type")
                    dict.setObject("Servo", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Increment")
                }
            } else if brick.type == .If {
                if brick.bricks.count > 0 {
                    dict.setObject("If", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setObject("Expression", forKey: "Type")
                    condition.setObject(brick.label2Text!, forKey: "Op")
                    condition.setObject(self.generateDictForText(brick.button1Text!), forKey: "Left")
                    condition.setObject(self.generateDictForText(brick.button2Text!), forKey: "Right")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(++beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    pages.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .RepeatFor {
                if brick.bricks.count > 0 {
                    dict.setObject("Repeat", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setValue("Constant", forKey: "Type")
                    condition.setValue(NSNumber(double: Double(brick.button1Text!)!), forKey: "Value")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(++beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    pages.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .RepeatUntil {
                if brick.bricks.count > 0 {
                    dict.setObject("Repeat", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setObject("Expression", forKey: "Type")
                    condition.setObject(brick.label2Text!, forKey: "Op")
                    condition.setObject(self.generateDictForText(brick.button1Text!), forKey: "Left")
                    condition.setObject(self.generateDictForText(brick.button2Text!), forKey: "Right")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(++beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    pages.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .Sleep {
                dict.setObject("Sleep", forKey: "Type")
                dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Param")
            } else if brick.type == .IFTTTMaker {
                if brick.label1Text == "Get Weather" {
                    dict.setObject("IFTTTMaker", forKey: "Type")
                    dict.setObject("https://maker.ifttt.com/trigger/iot4us_weather/with/key/ciwt1IvJ6CICVWDs3mvejO", forKey: "Url")
                    dict.setObject(["value1": ["Type": "CurrentTemperature", "Device": "TempSensor"], "value2": ["Type": "CurrentHumidity", "Device": "TempSensor"]], forKey: "Data")
                } else if brick.label1Text == "Button Pressed" {
                    dict.setObject("IFTTTMaker", forKey: "Type")
                    dict.setObject("https://maker.ifttt.com/trigger/iot4us_button_pressed/with/key/ciwt1IvJ6CICVWDs3mvejO", forKey: "Url")
                    dict.setObject([], forKey: "Data")
                } else {
                    continue
                }
            }
            nodes.addObject(dict)
        }
        
        page.setObject(nodes, forKey: "Nodes")
        page.setObject("Main", forKey: "Name")
        pages.addObject(page)
        ret.setObject(pages, forKey: "Pages")
        
        return ret
    }
    
    class func generateDictForText(text: String) -> NSDictionary {
        if text == "Get Button Status" {
            return ["Type": "GetButtonStatus", "Device": "Button"]
        } else if text == "Current Temperature" {
            return ["Type": "CurrentTemperature", "Device": "TempSensor"]
        } else if text == "Current Humidity" {
            return ["Type": "CurrentHumidity", "Device": "TempSensor"]
        } else {
            let num = NSNumber(double: Double(text)!)
            return ["Type": "Constant",
                "Value": num]
        }
    }
    
    class func traverseAndGetJSONObject(bricks: [Brick], count: Int) -> (NSMutableArray, Int) {
        var beginCount = count + 1
        let ret = NSMutableArray()
        let page = NSMutableDictionary()
        let nodes = NSMutableArray()
        for brick in bricks {
            let dict = NSMutableDictionary()
            if brick.type == .LED {
                if brick.label1Text == "Set Red LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("RedLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Set Green LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("GreenLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Set Blue LED" {
                    dict.setObject("LedSet", forKey: "Type")
                    dict.setObject("BlueLed", forKey: "Device")
                    dict.setValue(self.generateDictForText(brick.button1Text!), forKey: "Value")
                } else if brick.label1Text == "Blink Red LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("RedLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Blink Green LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("GreenLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Blink Blue LED" {
                    dict.setObject("LedBlink", forKey: "Type")
                    dict.setObject("BlueLed", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "BlinkInterval")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "NumberOfBlinks")
                } else if brick.label1Text == "Set RGBLED" {
                    dict.setObject("SetRgbLed", forKey: "Type")
                    dict.setObject("RgbLed", forKey: "Device")
                    let rgb = brick.button1Text!.componentsSeparatedByString(",") as [String]
                    dict.setObject(self.generateDictForText(rgb[0]), forKey: "R")
                    dict.setObject(self.generateDictForText(rgb[1]), forKey: "G")
                    dict.setObject(self.generateDictForText(rgb[2]), forKey: "B")
                } else {
                    print("\"\(brick.label1Text)\"")
                }
            } else if brick.type == .Devices {
                if brick.label1Text == "Wait Button Press" {
                    dict.setObject("WaitButtonPress", forKey: "Type")
                    dict.setObject("Button", forKey: "Device")
                } else if brick.label1Text == "Set Servo Angle" {
                    dict.setObject("SetServoAngle", forKey: "Type")
                    dict.setObject("Servo", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Angle")
                } else if brick.label1Text == "Step Servo Angle" {
                    dict.setObject("StepServoAngle", forKey: "Type")
                    dict.setObject("Servo", forKey: "Device")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Increment")
                }
            } else if brick.type == .If {
                if brick.bricks.count > 0 {
                    dict.setObject("If", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setObject("Expression", forKey: "Type")
                    condition.setObject(brick.label2Text!, forKey: "Op")
                    condition.setObject(self.generateDictForText(brick.button1Text!), forKey: "Left")
                    condition.setObject(self.generateDictForText(brick.button2Text!), forKey: "Right")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    ret.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .RepeatFor {
                if brick.bricks.count > 0 {
                    dict.setObject("Repeat", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setValue("Constant", forKey: "Type")
                    condition.setValue(NSNumber(double: Double(brick.button1Text!)!), forKey: "Value")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    ret.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .RepeatUntil {
                if brick.bricks.count > 0 {
                    dict.setObject("Repeat", forKey: "Type")
                    let condition = NSMutableDictionary()
                    condition.setObject("Expression", forKey: "Type")
                    condition.setObject(brick.label2Text!, forKey: "Op")
                    condition.setObject(self.generateDictForText(brick.button1Text!), forKey: "Left")
                    condition.setObject(self.generateDictForText(brick.button2Text!), forKey: "Right")
                    dict.setObject(condition, forKey: "Condition")
                    dict.setObject("SubPage\(beginCount)", forKey: "Page")
                    var tempPages: NSMutableArray
                    (tempPages, beginCount) = traverseAndGetJSONObject(brick.bricks, count: beginCount)
                    ret.addObjectsFromArray(tempPages as [AnyObject])
                } else {
                    continue
                }
            } else if brick.type == .Sleep {
                dict.setObject("Sleep", forKey: "Type")
                dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Param")
            } else if brick.type == .IFTTTMaker {
                if brick.label1Text == "Get Weather" {
                    dict.setObject("IFTTTMaker", forKey: "Type")
                    dict.setObject("https://maker.ifttt.com/trigger/iot4us_weather/with/key/ciwt1IvJ6CICVWDs3mvejO", forKey: "Url")
                    dict.setObject(["value1": ["Type": "CurrentTemperature", "Device": "TempSensor"], "value2": ["Type": "CurrentHumidity", "Device": "TempSensor"]], forKey: "Data")
                } else if brick.label1Text == "Button Pressed" {
                    dict.setObject("IFTTTMaker", forKey: "Type")
                    dict.setObject("https://maker.ifttt.com/trigger/iot4us_button_pressed/with/key/ciwt1IvJ6CICVWDs3mvejO", forKey: "Url")
                    dict.setObject([], forKey: "Data")
                } else {
                    continue
                }
            }
            nodes.addObject(dict)
        }
        
        page.setObject("SubPage\(count)", forKey: "Name")
        page.setObject(nodes, forKey: "Nodes")
        ret.addObject(page)
        
        return (ret, beginCount)
    }
    
    // MARK: Helper
    
    class func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        if NSJSONSerialization.isValidJSONObject(value) {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return (string) as String
                }
            } catch {
                print("error")
            }
        }
        return ""
    }
}
