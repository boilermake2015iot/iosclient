//
//  Project.swift
//  Simplify
//
//  Created by George Lo on 10/16/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class Project: NSObject, NSCoding {
    var name: String
    var lastModified: NSDate
    var deployTimes: Int
    var photoData: NSData
    
    override init() {
        self.name = ""
        self.deployTimes = 0
        self.lastModified = NSDate()
        self.photoData = NSData()
    }
    
    init(name: String, deployTimes: Int, lastModified: NSDate, photoData: NSData) {
        self.name = name
        self.deployTimes = deployTimes
        self.lastModified = lastModified
        self.photoData = photoData
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("1") as! String
        self.lastModified = aDecoder.decodeObjectForKey("2") as! NSDate
        self.deployTimes = aDecoder.decodeObjectForKey("3") as! Int
        self.photoData = aDecoder.decodeObjectForKey("4") as! NSData
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "1")
        aCoder.encodeObject(self.lastModified, forKey: "2")
        aCoder.encodeObject(self.deployTimes, forKey: "3")
        aCoder.encodeObject(self.photoData, forKey: "4")
    }
    
}
