//
//  BrickCell.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class BrickCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var detailButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userInteractionEnabled = true
        self.selectionStyle = .None
        
        self.backView.layer.cornerRadius = 10
        
        self.button1.layer.cornerRadius = 5
        self.button2.layer.cornerRadius = 5
        self.button3.layer.cornerRadius = 5
        
        self.detailButton.setImage(UIImage(named: "Right")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        self.detailButton.tintColor = UIColor.whiteColor()
        self.detailButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        self.detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.bringSubviewToFront(self.detailButton)
    }
    
    func setType(type: BrickType) {
        if type == .Message {
            self.backView.backgroundColor = MessageColor
        } else if type == .Devices {
            self.backView.backgroundColor = DevicesColor
        } else if type == .If {
            self.backView.backgroundColor = IfColor
        } else if type == .RepeatFor {
            self.backView.backgroundColor = RepeatForColor
        } else if type == .RepeatUntil {
            self.backView.backgroundColor = RepeatUntilColor
        } else if type == .Sleep {
            self.backView.backgroundColor = SleepColor
        } else if type == .IFTTTMaker {
            self.backView.backgroundColor = IFTTTMakerColor
        } else if type == .Grid {
            self.backView.backgroundColor = GridColor
        }
        self.backView.layer.borderWidth = 1
        self.backView.layer.borderColor = self.backView.backgroundColor?.darkerColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (editing) {
            for view in subviews as [UIView] {
                if view.dynamicType.description().rangeOfString("Reorder") != nil {
                    for subview in view.subviews as! [UIImageView] {
                        if subview.isKindOfClass(UIImageView) {
                            subview.contentMode = UIViewContentMode.ScaleAspectFill
                            subview.image = UIImage(named: "Move")
                        }
                    }
                }
            }
        }
    }

}
