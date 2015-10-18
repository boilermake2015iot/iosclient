//
//  Extensions.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

extension UIColor {
    func darkerColor() -> UIColor {
        var darkerColor = UIColor()
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            darkerColor = UIColor(red: min(r - 0.2, 1.0), green: min(g - 0.2, 1.0), blue: min(b - 0.2, 1.0), alpha: a)
        }
        return darkerColor
    }
}
