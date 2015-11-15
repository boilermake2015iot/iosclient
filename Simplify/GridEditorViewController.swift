//
//  GridEditorViewController.swift
//  Simplify
//
//  Created by George Lo on 11/13/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit
import JHColorPicker

private let reuseIdentifier = "Cell"

protocol GridEditorDelegate {
    func gridEditorDidFinishedEditing(code: String)
}

class GridEditorViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var delegate: GridEditorDelegate?
    var colors = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
    }
    
    func done() {
        var rgbStrs = [String]()
        for color in self.colors {
            let rgb = ["\(color[0])", "\(color[1])", "\(color[2])"]
            let rgbStr = rgb.joinWithSeparator(",")
            rgbStrs.append(rgbStr)
        }
        delegate?.gridEditorDidFinishedEditing(rgbStrs.joinWithSeparator(" | "))
        self.dismissViewControllerAnimated(true, completion: {
            (self.delegate as! FlowViewController).attemptToSaveBrick()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let r = Double(self.colors[indexPath.row][0])
        let g = Double(self.colors[indexPath.row][1])
        let b = Double(self.colors[indexPath.row][2])
        cell.backgroundColor = UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1)
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 0.5
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let colorPickerController = JHColorPickerController()
        colorPickerController.previousColor = collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor
        colorPickerController.completion = { (selectedColor: UIColor) in
            var rf = CGFloat(0), gf = CGFloat(0), bf = CGFloat(0)
            selectedColor.getRed(&rf, green: &gf, blue: &bf, alpha: nil)
            let r = Double(rf * 255)
            let g = Double(gf * 255)
            let b = Double(bf * 255)
            self.colors[indexPath.row] = [Int(r), Int(g), Int(b)]
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell!.backgroundColor = UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1)
        }
        self.navigationController?.pushViewController(colorPickerController, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 100, left: 260, bottom: 10, right: 260)
    }

}
