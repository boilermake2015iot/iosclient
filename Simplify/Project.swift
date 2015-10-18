//
//  Project.swift
//  Simplify
//
//  Created by George Lo on 10/16/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class Project: NSObject {
    var name: String
    var lastModified: NSDate
    var photoData: NSData
    
    override init() {
        self.name = ""
        self.lastModified = NSDate()
        self.photoData = NSData()
    }
    
    init(name: String, lastModified: NSDate, photoData: NSData) {
        self.name = name
        self.lastModified = lastModified
        self.photoData = photoData
    }
    
}
