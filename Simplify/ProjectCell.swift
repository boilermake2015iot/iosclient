//
//  ProjectCell.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

protocol ProjectCellDelegate {
    func deployTappedForCellAtIndexPath(indexPath: NSIndexPath)
    func editTappedForCellAtIndexPath(indexPath: NSIndexPath)
    func deleteTappedForCellAtIndexPath(indexPath: NSIndexPath)
}

class ProjectCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deployButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: ProjectCellDelegate?
    
    override func awakeFromNib() {
        self.bringSubviewToFront(deployButton)
        self.bringSubviewToFront(editButton)
        self.bringSubviewToFront(deleteButton)
    }
    
    @IBAction func deployTapped(sender: AnyObject) {
        delegate?.deployTappedForCellAtIndexPath(NSIndexPath(forRow: self.tag, inSection: 0))
    }
    
    @IBAction func editTapped(sender: AnyObject) {
        delegate?.editTappedForCellAtIndexPath(NSIndexPath(forRow: self.tag, inSection: 0))
    }
    @IBAction func deleteTapped(sender: AnyObject) {
        delegate?.deleteTappedForCellAtIndexPath(NSIndexPath(forRow: self.tag, inSection: 0))
    }
}
