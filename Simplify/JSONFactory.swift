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
            if brick.type == .Message {
                if brick.label1Text != "pitch " && brick.label1Text != "roll " && brick.label1Text != "yaw " && brick.label1Text != "north " {
                    if brick.label1Text == "Format" {
                        let temp = NSMutableDictionary()
                        temp.setObject("Format", forKey: "Type")
                        temp.setObject(brick.button1Text!, forKey: "Text")
                        temp.setObject(self.generateParamsForText(brick.button2Text!), forKey: "Params")
                        let params = [temp]
                        dict.setObject("SenseHat", forKey: "Type")
                        dict.setObject("show_message", forKey: "Command")
                        dict.setObject(params, forKey: "Params")
                    } else {
                        var formatString = "\(brick.label1Text){}"
                        if brick.label2Text != nil {
                            formatString = "\(brick.label1Text){}\(brick.label2Text!)"
                        }
                        let temp = NSMutableDictionary()
                        temp.setObject("Format", forKey: "Type")
                        temp.setObject(formatString, forKey: "Text")
                        temp.setObject([self.generateDictForText(brick.button1Text!)], forKey: "Params")
                        let params = [temp]
                        dict.setObject("SenseHat", forKey: "Type")
                        dict.setObject("show_message", forKey: "Command")
                        dict.setObject(params, forKey: "Params")
                    }
                } else {
                    let temp = NSMutableDictionary()
                    temp.setObject("Format", forKey: "Type")
                    temp.setObject("\(brick.label1Text){}", forKey: "Text")
                    temp.setObject([self.generateKeyDictForText(brick.button1Text!, key: brick.label1Text)], forKey: "Params")
                    let params = [temp]
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("show_message", forKey: "Command")
                    dict.setObject(params, forKey: "Params")
                }
            } else if brick.type == .Devices {
                if brick.label1Text == "Set" {
                    dict.setObject("Set \(brick.button1Text!)", forKey: "Type")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "Value")
                } else if brick.label1Text == "Joystick" {
                    dict.setObject("Joystick", forKey: "Type")
                } else if brick.label1Text == "Rand" {
                    dict.setObject("Rand", forKey: "Type")
                } else {
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_rotation", forKey: "Command")
                    let temp = NSMutableDictionary()
                    temp.setObject("Constant", forKey: "Type")
                    temp.setValue(Int(brick.label1Text.componentsSeparatedByString(" ")[3]), forKey: "Value")
                    dict.setObject([temp], forKey: "Params")
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
                    //                    let condition = NSMutableDictionary()
                    //                    condition.setValue("Constant", forKey: "Type")
                    //                    condition.setValue(NSNumber(double: Double(brick.button1Text!)!), forKey: "Value")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Condition")
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
            } else if brick.type == .Grid {
                if brick.label1Text == "8 x 8" {
                    let textComps = brick.button1Text!.componentsSeparatedByString(" | ")
                    var rgbAry = [[Int]]()
                    for textComp in textComps {
                        let comp = textComp.componentsSeparatedByString(",")
                        let rgb = [Int(comp[0])!, Int(comp[1])!, Int(comp[2])!]
                        rgbAry.append(rgb)
                    }
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_pixels", forKey: "Command")
                    dict.setObject([["Type": "Constant", "Value": rgbAry]], forKey: "Params")
                } else {
                    var params = [NSDictionary]()
                    var comps = brick.button3Text!.componentsSeparatedByString(",")
                    params.append(self.generateDictForText(brick.button1Text!))
                    params.append(self.generateDictForText(brick.button2Text!))
                    params.append(["Type": "Constant", "Value": [Int(comps[0])!, Int(comps[1])!, Int(comps[2])!]])
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_pixel", forKey: "Command")
                    dict.setObject(params, forKey: "Params")
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
        if text == "Current Temperature" {
            return ["Type": "SenseHat", "Command": "get_temperature", "Params": []]
        } else if text == "Current Humidity" {
            return ["Type": "SenseHat", "Command": "get_humidity", "Params": []]
        } else if text.uppercaseString.hasPrefix("GET") {
            return ["Type": "\(text)"]
        } else if text == "Joystick" {
            return ["Type": "Joystick"]
        } else if text == "Rand" {
            return ["Type": "Rand"]
        } else {
            let doubleText = Double(text)
            if doubleText != nil {
                return ["Type": "Constant", "Value": doubleText!]
            } else if text == "Compass value" {
                return ["Type": "SenseHat", "Command": "get_compass", "Params": []]
            } else {
                return ["Type": "Constant", "Value": text]
            }
        }
    }
    
    class func generateParamsForText(text: String) -> [NSDictionary] {
        var ret = [NSDictionary]()
        let comps = text.componentsSeparatedByString(",")
        for comp in comps {
            ret.append(self.generateDictForText(comp))
        }
        return ret
    }
    
    class func generateKeyDictForText(text: String, key: String?) -> NSDictionary {
        if text == "Accelerometer value" {
            let dict = NSMutableDictionary()
            dict.setObject("SenseHat", forKey: "Type")
            dict.setObject("get_accelerometer", forKey: "Command")
            dict.setObject([], forKey: "Params")
            return ["Type": "GetKey", "Key": key!.stringByReplacingOccurrencesOfString(" ", withString: ""), "Dict": dict]
        } else if text == "Gyroscope value" {
            let dict = NSMutableDictionary()
            dict.setObject("SenseHat", forKey: "Type")
            dict.setObject("get_gyroscope", forKey: "Command")
            dict.setObject([], forKey: "Params")
            return ["Type": "GetKey", "Key": key!.stringByReplacingOccurrencesOfString(" ", withString: ""), "Dict": dict]
        } else {
            return ["Type": "SenseHat", "Command": "get_compass", "Params": []]
        }
    }
    
    class func traverseAndGetJSONObject(bricks: [Brick], count: Int) -> (NSMutableArray, Int) {
        var beginCount = count + 1
        let ret = NSMutableArray()
        let page = NSMutableDictionary()
        let nodes = NSMutableArray()
        for brick in bricks {
            let dict = NSMutableDictionary()
            if brick.type == .Message {
                if brick.label1Text != "pitch " && brick.label1Text != "roll " && brick.label1Text != "yaw " && brick.label1Text != "north " {
                    if brick.label1Text == "Format" {
                        let temp = NSMutableDictionary()
                        temp.setObject("Format", forKey: "Type")
                        temp.setObject(brick.button1Text!, forKey: "Text")
                        temp.setObject(self.generateParamsForText(brick.button2Text!), forKey: "Params")
                        let params = [temp]
                        dict.setObject("SenseHat", forKey: "Type")
                        dict.setObject("show_message", forKey: "Command")
                        dict.setObject(params, forKey: "Params")
                    } else {
                        var formatString = "\(brick.label1Text){}"
                        if brick.label2Text != nil {
                            formatString = "\(brick.label1Text){}\(brick.label2Text!)"
                        }
                        let temp = NSMutableDictionary()
                        temp.setObject("Format", forKey: "Type")
                        temp.setObject(formatString, forKey: "Text")
                        temp.setObject([self.generateDictForText(brick.button1Text!)], forKey: "Params")
                        let params = [temp]
                        dict.setObject("SenseHat", forKey: "Type")
                        dict.setObject("show_message", forKey: "Command")
                        dict.setObject(params, forKey: "Params")
                    }
                } else {
                    let temp = NSMutableDictionary()
                    temp.setObject("Format", forKey: "Type")
                    temp.setObject("\(brick.label1Text){}", forKey: "Text")
                    temp.setObject([self.generateKeyDictForText(brick.button1Text!, key: brick.label1Text)], forKey: "Params")
                    let params = [temp]
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("show_message", forKey: "Command")
                    dict.setObject(params, forKey: "Params")
                }
            } else if brick.type == .Devices {
                if brick.label1Text == "Set" {
                    dict.setObject("Set \(brick.button1Text!)", forKey: "Type")
                    dict.setObject(self.generateDictForText(brick.button2Text!), forKey: "Value")
                } else if brick.label1Text == "Joystick" {
                    dict.setObject("Joystick", forKey: "Type")
                } else if brick.label1Text == "Rand" {
                    dict.setObject("Rand", forKey: "Type")
                } else {
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_rotation", forKey: "Command")
                    let temp = NSMutableDictionary()
                    temp.setObject("Constant", forKey: "Type")
                    temp.setValue(Int(brick.label1Text.componentsSeparatedByString(" ")[3]), forKey: "Value")
                    dict.setObject([temp], forKey: "Params")
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
//                    let condition = NSMutableDictionary()
//                    condition.setValue("Constant", forKey: "Type")
//                    condition.setValue(NSNumber(double: Double(brick.button1Text!)!), forKey: "Value")
                    dict.setObject(self.generateDictForText(brick.button1Text!), forKey: "Condition")
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
            } else if brick.type == .Grid {
                if brick.label1Text == "8 x 8" {
                    let textComps = brick.button1Text!.componentsSeparatedByString(" | ")
                    var rgbAry = [[Int]]()
                    for textComp in textComps {
                        let comp = textComp.componentsSeparatedByString(",")
                        let rgb = [Int(comp[0])!, Int(comp[1])!, Int(comp[2])!]
                        rgbAry.append(rgb)
                    }
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_pixels", forKey: "Command")
                    dict.setObject([["Type": "Constant", "Value": rgbAry]], forKey: "Params")
                } else {
                    var params = [NSDictionary]()
                    var comps = brick.button3Text!.componentsSeparatedByString(",")
                    params.append(self.generateDictForText(brick.button1Text!))
                    params.append(self.generateDictForText(brick.button2Text!))
                    params.append(["Type": "Constant", "Value": [Int(comps[0])!, Int(comps[1])!, Int(comps[2])!]])
                    dict.setObject("SenseHat", forKey: "Type")
                    dict.setObject("set_pixel", forKey: "Command")
                    dict.setObject(params, forKey: "Params")
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
