//
//  Brick.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

enum BrickType: Int {
    case Undefined = -1,
         Message = 0,
         Devices = 1,
         If = 2,
         RepeatFor = 3,
         RepeatUntil = 4,
         Sleep = 5,
         IFTTTMaker = 6,
         Grid = 7
}

enum BrickStyle: Int {
    case Undefined = -1,
         TextInput = 0,
         TextInputText = 1,
         TextInputTextInput = 2,
         TextInputTextInputText = 3
}

class Brick: NSObject, NSCoding, NSCopying {
    var label1Text: String
    var button1Text: String?
    var label2Text: String?
    var button2Text: String?
    var label3Text: String?
    var button3Text: String?
    var bricks = [Brick]()
    
    var type: BrickType
    var style: BrickStyle
    
    override init() {
        self.type = .Undefined
        self.style = .Undefined
        self.label1Text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.label1Text = aDecoder.decodeObjectForKey("1") as! String
        self.button1Text = aDecoder.decodeObjectForKey("2") as? String
        self.label2Text = aDecoder.decodeObjectForKey("3") as? String
        self.button2Text = aDecoder.decodeObjectForKey("4") as? String
        self.label3Text = aDecoder.decodeObjectForKey("5") as? String
        self.button3Text = aDecoder.decodeObjectForKey("9") as? String
        self.bricks = aDecoder.decodeObjectForKey("6") as! [Brick]
        self.type = BrickType(rawValue: aDecoder.decodeIntegerForKey("7"))!
        self.style = BrickStyle(rawValue: aDecoder.decodeIntegerForKey("8"))!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.label1Text, forKey: "1")
        aCoder.encodeObject(self.button1Text, forKey: "2")
        aCoder.encodeObject(self.label2Text, forKey: "3")
        aCoder.encodeObject(self.button2Text, forKey: "4")
        aCoder.encodeObject(self.label3Text, forKey: "5")
        aCoder.encodeObject(self.button3Text, forKey: "9")
        aCoder.encodeObject(self.bricks, forKey: "6")
        aCoder.encodeInteger(self.type.rawValue, forKey: "7")
        aCoder.encodeInteger(self.style.rawValue, forKey: "8")
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let brick = Brick()
        brick.label1Text = self.label1Text
        brick.button1Text = self.button1Text
        brick.label2Text = self.label2Text
        brick.button2Text = self.button2Text
        brick.label3Text = self.label3Text
        brick.button3Text = self.button3Text
        brick.bricks = self.bricks
        brick.type = self.type
        brick.style = self.style
        return brick
    }
}
