//
//  Brick.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

enum BrickType {
    case Undefined
    
    case Constant
    case Expression
    case If
    case RepeatFor
    case RepeatUntil
    case Sleep
    case IFTTTMaker
}

enum BrickStyle {
    case Undefined
    
    case TextInput
    case TextInputText
    case TextInputTextInput
    case TextInputTextInputText
}

class Brick: NSObject {
    var label1Text: String
    var button1Text: String?
    var label2Text: String?
    var button2Text: String?
    var label3Text: String?
    var bricks = [Brick]()
    
    var type: BrickType
    var style: BrickStyle
    
    override init() {
        self.type = .Undefined
        self.style = .Undefined
        self.label1Text = ""
    }
}
