//
//  GridBrick.swift
//  Simplify
//
//  Created by George Lo on 11/13/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class GridBrick: Brick {
    override init() {
        super.init()
        self.type = .Grid
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
}
