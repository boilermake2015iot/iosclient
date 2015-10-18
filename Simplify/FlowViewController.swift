//
//  FlowViewController.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

protocol FlowViewDelegate {
    func finishWithBricks(bricks: [Brick])
}

class FlowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FlowViewDelegate, BrickTransactionDelegate {
    
    var isAtRoot = true
    var navigationTitle = "FLOW"
    var bricks = [Brick]()
    var tableView: UITableView?
    var selectedRow: Int = 0
    var delegate: FlowViewDelegate?
    let editButton = UIButton(type: UIButtonType.RoundedRect)
    
    override func viewWillAppear(animated: Bool) {
        (self.splitViewController!.viewControllers[0] as! MainViewController).delegate = self
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.view.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        
        if isAtRoot {
            let navigationView = UILabel(frame: CGRectMake(2.5, 20, 703 - 65 - 7.5, 60))
            navigationView.textAlignment = NSTextAlignment.Center
            navigationView.font = UIFont.boldSystemFontOfSize(32)
            navigationView.text = navigationTitle
            navigationView.textColor = UIColor.grayColor()
            navigationView.backgroundColor = UIColor(white: 0.98, alpha: 1)
            navigationView.layer.cornerRadius = 5
            navigationView.clipsToBounds = true
            self.view.addSubview(navigationView)
        } else {
            let backButton = UIButton(type: UIButtonType.RoundedRect)
            backButton.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
            backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
            backButton.frame = CGRectMake(2.5, 20, 60, 60)
            backButton.backgroundColor = UIColor(white: 0.98, alpha: 1)
            backButton.layer.cornerRadius = 5
            self.view.addSubview(backButton)
            
            let navigationView = UILabel(frame: CGRectMake(67.5, 20, 703 - 72.5 - 65, 60))
            navigationView.font = UIFont.boldSystemFontOfSize(28)
            navigationView.textAlignment = NSTextAlignment.Center
            navigationView.text = navigationTitle
            navigationView.textColor = UIColor.grayColor()
            navigationView.backgroundColor = UIColor(white: 0.98, alpha: 1)
            navigationView.layer.cornerRadius = 5
            navigationView.clipsToBounds = true
            self.view.addSubview(navigationView)
        }
        
        editButton.setImage(UIImage(named: "Modify"), forState: UIControlState.Normal)
        editButton.addTarget(self, action: "enterExitEditMode", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.frame = CGRectMake(703 - 65, 20, 60, 60)
        editButton.backgroundColor = UIColor(white: 0.98, alpha: 1)
        editButton.layer.cornerRadius = 5
        editButton.clipsToBounds = true
        self.view.addSubview(editButton)
        
        self.tableView = UITableView(frame: CGRectMake(2.5, 85, 703 - 7.5, ScreenHeight - 90), style: .Plain)
        self.tableView?.registerNib(UINib(nibName: "BrickCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView?.rowHeight = 150
        self.tableView?.separatorColor = UIColor.clearColor()
        self.tableView?.backgroundColor = UIColor.whiteColor()
        self.tableView?.layer.cornerRadius = 5
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(self.tableView!)
    }
    
    func enterExitEditMode() {
        if self.tableView?.editing == true {
            editButton.setImage(UIImage(named: "Modify"), forState: UIControlState.Normal)
            self.tableView?.setEditing(false, animated: true)
        } else {
            editButton.setImage(UIImage(named: "Done"), forState: UIControlState.Normal)
            self.tableView?.setEditing(true, animated: true)
        }
    }
    
    func goBack() {
        delegate?.finishWithBricks(bricks)
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bricks.count
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            bricks.removeAtIndex(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let brick = bricks[sourceIndexPath.row]
        bricks.removeAtIndex(sourceIndexPath.row)
        bricks.insert(brick, atIndex: destinationIndexPath.row)
        self.tableView?.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BrickCell
        
        let brickType = bricks[indexPath.row].type
        cell.setType(brickType)
        
        cell.label1.text = bricks[indexPath.row].label1Text
        cell.button1.setTitle("", forState: UIControlState.Normal)
        cell.label2.text = ""
        cell.button2.setTitle("", forState: UIControlState.Normal)
        cell.label3.text = ""
        if let button1Text = bricks[indexPath.row].button1Text {
            cell.button1.tag = indexPath.row
            cell.button1.setTitle(button1Text, forState: UIControlState.Normal)
            cell.button1.addTarget(self, action: "changeButton1Text:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.button1.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        } else {
            cell.button1.backgroundColor = UIColor.clearColor()
        }
        if let label2Text = bricks[indexPath.row].label2Text {
            cell.label2.text = label2Text
        }
        if let button2Text = bricks[indexPath.row].button2Text {
            cell.button2.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            cell.button2.tag = indexPath.row
            cell.button2.addTarget(self, action: "changeButton2Text:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.button2.setTitle(button2Text, forState: UIControlState.Normal)
        } else {
            cell.button2.backgroundColor = UIColor.clearColor()
        }
        if let label3Text = bricks[indexPath.row].label3Text {
            cell.label3.text = label3Text
        }
        
        cell.topLine.alpha = 1
        cell.bottomLine.alpha = 1
        if indexPath.row == 0 {
            cell.topLine.alpha = 0
        }
        if indexPath.row == bricks.count - 1 {
            cell.bottomLine.alpha = 0
        }
        
        if brickType == .If || brickType == .RepeatFor || brickType == .RepeatUntil {
            cell.detailButton.tag = indexPath.row
            cell.detailButton.addTarget(self, action: "toDetailView:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.detailButton.alpha = 1
        } else {
            cell.detailButton.alpha = 0
        }

        return cell
    }
    
    func toDetailView(sender: UIButton) {
        self.selectedRow = sender.tag
        self.proceedToDetail()
    }
    
    func changeButton1Text(sender: UIButton) {
        let alertController = UIAlertController(title: "First", message: "Old value: \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                textField.placeholder = "Value"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.bricks[sender.tag].button1Text = alertController.textFields![0].text
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func changeButton2Text(sender: UIButton) {
        let alertController = UIAlertController(title: "Second", message: "Old value: \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Value"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.bricks[sender.tag].button2Text = alertController.textFields![0].text
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let brickType = bricks[indexPath.row].type
        if brickType == .If || brickType == .RepeatFor || brickType == .RepeatUntil {
            self.selectedRow = indexPath.row
            self.proceedToDetail()
        }
    }
    
    func proceedToDetail() {
        let brickType = self.bricks[selectedRow].type
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FlowViewID") as! FlowViewController
        if brickType == .If {
            viewController.navigationTitle = "IF"
        } else if brickType == .RepeatFor {
            viewController.navigationTitle = "REPEAT FOR"
        } else if brickType == .RepeatUntil {
            viewController.navigationTitle = "REPEAT UNTIL"
        }
        viewController.isAtRoot = false
        viewController.delegate = self
        viewController.bricks = self.bricks[selectedRow].bricks
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func finishWithBricks(bricks: [Brick]) {
        self.bricks[selectedRow].bricks = bricks
    }
    
    func addBrick(brick: Brick) {
        bricks.append(brick)
        self.tableView?.reloadData()
    }

}
