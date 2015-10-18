//
//  MiniCell.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class MiniCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        self.backView.layer.cornerRadius = 10
        
        self.button1.layer.cornerRadius = 5
        self.button2.layer.cornerRadius = 5
    }
    
    func setType(type: BrickType) {
        if type == .Constant {
            self.backView.backgroundColor = ConstantColor
        } else if type == .Expression {
            self.backView.backgroundColor = ExpressionColor
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
        }
        self.backView.layer.borderWidth = 1
        self.backView.layer.borderColor = self.backView.backgroundColor?.darkerColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
