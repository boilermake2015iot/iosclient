//
//  MainViewController.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit
import MRProgress

protocol BrickTransactionDelegate {
    func addBrick(brick: Brick)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    var selectedTagIndex = 0
    var bricks = [Brick]()
    var project: Project?
    var delegate: BrickTransactionDelegate?
    
    var tags = [
        [
            "title": "LED",
            "color": LEDColor
        ],
        [
            "title": "Devices",
            "color": DevicesColor
        ],
        [
            "title": "If",
            "color": IfColor
        ],
        [
            "title": "RepeatFor",
            "color": RepeatForColor
        ],
        [
            "title": "RepeatUntil",
            "color": RepeatUntilColor
        ],
        [
            "title": "Sleep",
            "color": SleepColor
        ],
        [
            "title": "IFTTTMaker",
            "color": IFTTTMakerColor
        ]
    ]
    
    // MARK: View controller cycles
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "writeBricksToUserDefaults:", name: "SaveBricks", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bricks = BricksManager.getLEDBricks()
        self.project = (self.splitViewController as! ProjectViewController).project
        self.view.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        
        let leftView = UITableView(frame: CGRectMake(5, 20, 320 - 7.5, self.view.frame.height - 90), style: .Plain)
        leftView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
        leftView.rowHeight = 80
        leftView.dataSource = self
        leftView.delegate = self
        leftView.layer.cornerRadius = 5
        leftView.registerNib(UINib(nibName: "MiniBrick", bundle: nil), forCellReuseIdentifier: "Cell")
        leftView.showsVerticalScrollIndicator = false
        self.tableView = leftView
        self.view.addSubview(leftView)
        
        let headerView = UIView(frame: CGRectMake(5, 20, 320 - 7.5, 320))
        headerView.addSubview(self.createTitleView(leftView.frame.width))
        headerView.addSubview(self.createTagView(leftView.frame.width))
        headerView.addSubview(self.createBorderView(leftView.frame.width))
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii: CGSize(width: 5, height: 5)).CGPath
        headerView.layer.mask = maskLayer
        self.view.addSubview(headerView)
        
        let deployButton = UIButton(type: UIButtonType.RoundedRect)
        deployButton.addTarget(self, action: "deploy", forControlEvents: UIControlEvents.TouchUpInside)
        deployButton.frame = CGRectMake(5, self.view.frame.height - 65, 320 - 7.5, 60)
        deployButton.setTitle("Deploy", forState: UIControlState.Normal)
        deployButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deployButton.backgroundColor = UIColor(red: 124.0/255, green: 166.0/255, blue: 192.0/255, alpha: 1)
        deployButton.layer.cornerRadius = 5
        deployButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        self.view.addSubview(deployButton)
    }
    
    func deploy() {
        DeployFactory.deploy(self.project!, viewcontroller: self.splitViewController!)
    }
    
    // MARK: Left views
    
    func createTitleView(width: CGFloat) -> UIView {
        let titleView = UIView(frame: CGRectMake(0, 0, width, 90))
        titleView.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1)
        
        let homeImageView = UIImageView(image: UIImage(named: "Home"))
        homeImageView.frame = CGRectMake(30, 25, 40, 40)
        homeImageView.userInteractionEnabled = true
        homeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "returnToHome"))
        titleView.addSubview(homeImageView)
        
        let titleLabel = UILabel(frame: CGRectMake(90, 0, width - 120, titleView.frame.height))
        titleLabel.font = UIFont.boldSystemFontOfSize(28)
        titleLabel.textColor = UIColor.grayColor()
        
        titleLabel.text = project?.name
        titleView.addSubview(titleLabel)
        
        return titleView
    }
    
    func createTagView(width: CGFloat) -> UIView {
        let tagView = UIView(frame: CGRectMake(0, 90, width, 210))
        tagView.backgroundColor = UIColor.whiteColor()
        
        func createCircleOfColor(color: UIColor) -> UIImage {
            let len: CGFloat = 20
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(len, len), false, 0)
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillEllipseInRect(context, CGRectMake(0, 0, len, len))
                
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
                
            return image
        }
        
        for (var i = 0; i < tags.count; i++) {
            let x = i < 4 ? CGFloat(25) : CGFloat(170)
            let margin = CGFloat(5)
            let buttonHeight = CGFloat((210 - margin * 5) / 4)
            let button = UIButton(type: UIButtonType.Custom)
            button.tag = i
            button.addTarget(self, action: "selectTag:", forControlEvents: UIControlEvents.TouchUpInside)
            button.frame = CGRectMake(x, buttonHeight * CGFloat(i % 4) + margin * (CGFloat(i % 4) + 1.0), 130, buttonHeight)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.setTitle("  " + (tags[i]["title"] as! String), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setImage(createCircleOfColor(tags[i]["color"] as! UIColor), forState: UIControlState.Normal)
            tagView.addSubview(button)
        }
        
        return tagView
    }
    
    func selectTag(sender: UIButton) {
        let index = sender.tag
        if index == 0 {
            bricks = BricksManager.getLEDBricks()
        } else if index == 1 {
            bricks = BricksManager.getDevicesBricks()
        } else if index == 2 {
            bricks = BricksManager.getIfBricks()
        } else if index == 3 {
            bricks = BricksManager.getRepeatForBricks()
        } else if index == 4 {
            bricks = BricksManager.getRepeatUntilBricks()
        } else if index == 5 {
            bricks = BricksManager.getSleepBricks()
        } else if index == 6 {
            bricks = BricksManager.getIFTTTBricks()
        }
        self.tableView?.reloadData()
    }
    
    func createBorderView(width: CGFloat) -> UIView {
        let borderView = UIView(frame: CGRectMake(0, 300, width, 20))
        borderView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return borderView
    }
    
    func returnToHome() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bricks.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MiniCell
        
        cell.setType(bricks[indexPath.row].type)
        
        cell.label1.text = bricks[indexPath.row].label1Text
        cell.button1.setTitle("", forState: UIControlState.Normal)
        cell.label2.text = ""
        cell.button2.setTitle("", forState: UIControlState.Normal)
        cell.label3.text = ""
        if let button1Text = bricks[indexPath.row].button1Text {
            cell.button1.setTitle(button1Text, forState: UIControlState.Normal)
            cell.button1.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        } else {
            cell.button1.backgroundColor = UIColor.clearColor()
        }
        if let label2Text = bricks[indexPath.row].label2Text {
            cell.label2.text = label2Text
        }
        if let button2Text = bricks[indexPath.row].button2Text {
            cell.button2.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            cell.button2.setTitle(button2Text, forState: UIControlState.Normal)
        } else {
            cell.button2.backgroundColor = UIColor.clearColor()
        }
        if let label3Text = bricks[indexPath.row].label3Text {
            cell.label3.text = label3Text
        }
        
        return cell
    }
    
    // MARK: Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.addBrick(bricks[indexPath.row].copy() as! Brick)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper
    
    func writeBricksToUserDefaults(notification: NSNotification) {
        let bricksToSave = notification.userInfo!["bricks"] as! [Brick]
        let object = NSKeyedArchiver.archivedDataWithRootObject(bricksToSave)
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: project!.name)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
