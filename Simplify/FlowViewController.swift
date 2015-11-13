//
//  FlowViewController.swift
//  Simplify
//
//  Created by George Lo on 10/17/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

protocol FlowViewDelegate {
    func saveBricks(bricks: [Brick])
}

class FlowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FlowViewDelegate, BrickTransactionDelegate, GridEditorDelegate {
    
    var currentButton = UIButton()
    var buttonTag = 0
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
        
        let mainVC = self.splitViewController!.viewControllers[0] as! MainViewController
        if isAtRoot {
            if let object = NSUserDefaults.standardUserDefaults().objectForKey(mainVC.project!.name) as? NSData {
                self.bricks = NSKeyedUnarchiver.unarchiveObjectWithData(object) as! [Brick]
            }
        }
        
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
        self.attemptToSaveBrick()
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
            self.bricks.removeAtIndex(indexPath.row)
            self.attemptToSaveBrick()
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let brick = bricks[sourceIndexPath.row]
        bricks.removeAtIndex(sourceIndexPath.row)
        bricks.insert(brick, atIndex: destinationIndexPath.row)
        self.attemptToSaveBrick()
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
        cell.button3.setTitle("", forState: UIControlState.Normal)
        if let button1Text = bricks[indexPath.row].button1Text {
            cell.button1.tag = indexPath.row
            cell.button1.setTitle(button1Text, forState: UIControlState.Normal)
            if brickType == .Grid && cell.label1.text == "8 x 8" {
                cell.button1.addTarget(self, action: "changeGrid:", forControlEvents: UIControlEvents.TouchUpInside)
            } else {
                cell.button1.addTarget(self, action: "changeButton1Text:", forControlEvents: UIControlEvents.TouchUpInside)
            }
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
        if let button3Text = bricks[indexPath.row].button3Text {
            cell.button3.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            cell.button3.tag = indexPath.row
            cell.button3.addTarget(self, action: "changeButton3Text:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.button3.setTitle(button3Text, forState: UIControlState.Normal)
        } else {
            cell.button3.backgroundColor = UIColor.clearColor()
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
    
    // MARK: Change Buttons' Text
    
    func changeButton1Text(sender: UIButton) {
        let alertController = UIAlertController(title: "First", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                textField.placeholder = "Value"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.bricks[sender.tag].button1Text = alertController.textFields![0].text
            self.attemptToSaveBrick()
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        let deviceAction = UIAlertAction(title: "Choose a device value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            let alertController2 = UIAlertController(title: "First", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
//            let buttonAction = UIAlertAction(title: "Get Button Status", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
//                self.bricks[sender.tag].button1Text = "Get Button Status"
//                self.attemptToSaveBrick()
//                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
//            })
            let temperatureAction = UIAlertAction(title: "Current Temperature", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button1Text = "Current Temperature"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let humidityAction = UIAlertAction(title: "Current Humidity", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button1Text = "Current Humidity"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let accelerometerAction = UIAlertAction(title: "Accelerometer value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button1Text = "Accelerometer value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let gyroscopeAction = UIAlertAction(title: "Gyroscope value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button1Text = "Gyroscope value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let compassAction = UIAlertAction(title: "Compass value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button1Text = "Compass value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
//            alertController2.addAction(buttonAction)
            alertController2.addAction(temperatureAction)
            alertController2.addAction(humidityAction)
            alertController2.addAction(accelerometerAction)
            alertController2.addAction(gyroscopeAction)
            alertController2.addAction(compassAction)
            alertController2.addAction(cancelAction)
            self.presentViewController(alertController2, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
        alertController.addAction(deviceAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func changeButton2Text(sender: UIButton) {
        let alertController = UIAlertController(title: "Second", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Value"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.bricks[sender.tag].button2Text = alertController.textFields![0].text
            self.attemptToSaveBrick()
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        let deviceAction = UIAlertAction(title: "Choose a device value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            let alertController2 = UIAlertController(title: "First", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
//            let buttonAction = UIAlertAction(title: "Get Button Status", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
//                self.bricks[sender.tag].button2Text = "Get Button Status"
//                self.attemptToSaveBrick()
//                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
//            })
            let temperatureAction = UIAlertAction(title: "Current Temperature", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button2Text = "Current Temperature"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let humidityAction = UIAlertAction(title: "Current Humidity", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button2Text = "Current Humidity"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let accelerometerAction = UIAlertAction(title: "Accelerometer value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button2Text = "Accelerometer value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let gyroscopeAction = UIAlertAction(title: "Gyroscope value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button2Text = "Gyroscope value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let compassAction = UIAlertAction(title: "Compass value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button2Text = "Compass value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
//            alertController2.addAction(buttonAction)
            alertController2.addAction(temperatureAction)
            alertController2.addAction(humidityAction)
            alertController2.addAction(accelerometerAction)
            alertController2.addAction(gyroscopeAction)
            alertController2.addAction(compassAction)
            alertController2.addAction(cancelAction)
            self.presentViewController(alertController2, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
        alertController.addAction(deviceAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func changeButton3Text(sender: UIButton) {
        let alertController = UIAlertController(title: "Second", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Value"
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.bricks[sender.tag].button3Text = alertController.textFields![0].text
            self.attemptToSaveBrick()
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        let deviceAction = UIAlertAction(title: "Choose a device value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            let alertController2 = UIAlertController(title: "First", message: "Example(Old Value): \(sender.titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
            //            let buttonAction = UIAlertAction(title: "Get Button Status", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            //                self.bricks[sender.tag].button3Text = "Get Button Status"
            //                self.attemptToSaveBrick()
            //                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            //            })
            let temperatureAction = UIAlertAction(title: "Current Temperature", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button3Text = "Current Temperature"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let humidityAction = UIAlertAction(title: "Current Humidity", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button3Text = "Current Humidity"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let accelerometerAction = UIAlertAction(title: "Accelerometer value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button3Text = "Accelerometer value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let gyroscopeAction = UIAlertAction(title: "Gyroscope value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button3Text = "Gyroscope value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let compassAction = UIAlertAction(title: "Compass value", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                self.bricks[sender.tag].button3Text = "Compass value"
                self.attemptToSaveBrick()
                self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
            //            alertController2.addAction(buttonAction)
            alertController2.addAction(temperatureAction)
            alertController2.addAction(humidityAction)
            alertController2.addAction(accelerometerAction)
            alertController2.addAction(gyroscopeAction)
            alertController2.addAction(compassAction)
            alertController2.addAction(cancelAction)
            self.presentViewController(alertController2, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in })
        alertController.addAction(deviceAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Table view delegate
    
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
    
    // MARK: Brick operations
    
    func attemptToSaveBrick() {
        if self.isAtRoot {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SaveBricks", object: nil, userInfo: ["bricks": self.bricks]))
        } else {
            delegate?.saveBricks(self.bricks)
        }
    }
    
    func saveBricks(bricks: [Brick]) {
        self.bricks[selectedRow].bricks = bricks
        delegate?.saveBricks(self.bricks)
        if self.isAtRoot {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SaveBricks", object: nil, userInfo: ["bricks": self.bricks]))
        }
    }
    
    func addBrick(brick: Brick) {
        self.bricks.append(brick)
        self.attemptToSaveBrick()
        self.tableView?.reloadData()
        self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: bricks.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
    }
    
    // MARK: Grid operations
    
    func changeGrid(sender: UIButton) {
        self.currentButton = sender
        self.buttonTag = sender.tag
        self.performSegueWithIdentifier("toGridEditor", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGridEditor" {
            let detailVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! GridEditorViewController
            detailVC.delegate = self
            let textComponents = self.currentButton.titleLabel!.text!.componentsSeparatedByString(" | ")
            var colors = [[Int]]()
            for textComponent in textComponents {
                let components = textComponent.componentsSeparatedByString(",")
                colors.append([Int(components[0])!, Int(components[1])!, Int(components[2])!])
            }
            detailVC.colors = colors
        }
    }
    
    func gridEditorDidFinishedEditing(code: String) {
        self.bricks[buttonTag].button1Text = code
        self.currentButton.setTitle(code, forState: .Normal)
    }

}
