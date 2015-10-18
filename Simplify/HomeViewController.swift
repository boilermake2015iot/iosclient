//
//  HomeViewController.swift
//  Simplify
//
//  Created by George Lo on 10/16/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProjectCellDelegate {
    
    let sunImageView = UIImageView(image: UIImage(named: "Sun"))
    let backImageView = UIImageView(image: UIImage(named: "BackWave"))
    let frontImageView = UIImageView(image: UIImage(named: "FrontWave"))
    
    var projects = [Project]()
    var timeCache = NSMutableArray()
    var selectedRow = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 244.0/255, green: 240.0/255, blue: 236.0/255, alpha: 1)
        
        self.setupDummyData()
        
        self.setupTopViews()
        self.setupMiddleViews()
        self.setupBottomViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startAnimateSun()
        self.startAnimateBackWave()
        self.startAnimateFrontWave()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        timeCache.removeAllObjects()
    }
    
    func setupDummyData() {
        let project1 = Project(name: "Raspberry Pi 2", lastModified: NSDate(), photoData: UIImagePNGRepresentation(UIImage(named: "RPI2")!)!)
        let project2 = Project(name: "Raspberry Pi", lastModified: NSDate(), photoData: UIImagePNGRepresentation(UIImage(named: "RPI")!)!)
        let project3 = Project(name: "Arduino Uno", lastModified: NSDate(), photoData: UIImagePNGRepresentation(UIImage(named: "ArduinoUno")!)!)
        projects.append(project1)
        projects.append(project2)
        projects.append(project3)
    }
    
    // MARK: Top Views
    
    func setupTopViews() {
        sunImageView.frame = CGRectMake(80, 50, 100, 100)
        sunImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(sunImageView)
        
        let titleLabel = UILabel(frame: CGRectMake(200, 50, ScreenWidth - 350, 100))
        titleLabel.text = "My IOT Projects"
        titleLabel.font = UIFont.boldSystemFontOfSize(30)
        titleLabel.textColor = UIColor.grayColor()
        self.view.addSubview(titleLabel)
        
        let addButton = UIButton(type: UIButtonType.RoundedRect)
        addButton.frame = CGRectMake(ScreenWidth - 200, 50, 120, 100)
        addButton.setTitle("+ Add", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        addButton.titleLabel?.font = UIFont.boldSystemFontOfSize(30)
        self.view.addSubview(addButton)
    }
    
    func startAnimateSun() {
        UIView.animateWithDuration(2, delay: 0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {
            self.sunImageView.transform = CGAffineTransformMakeRotation(CGFloat(90 * M_PI/180))
        }, completion: { (success: Bool) in
            self.sunImageView.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    // MARK: Middle Views
    
    func setupMiddleViews() {
        let projectLayout = UICollectionViewFlowLayout()
        projectLayout.minimumLineSpacing = 30
        projectLayout.itemSize = CGSizeMake(300, 430)
        projectLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        projectLayout.sectionInset = UIEdgeInsets(top: 10, left: 100, bottom: 10, right: 100)
        
        let projectView = UICollectionView(frame: CGRectMake(0, (ScreenHeight - 450) / 2, ScreenWidth, 450), collectionViewLayout: projectLayout)
        projectView.registerNib(UINib(nibName: "ProjectCell", bundle: nil), forCellWithReuseIdentifier: "Project")
        projectView.backgroundColor = UIColor.clearColor()
        projectView.showsHorizontalScrollIndicator = false
        projectView.dataSource = self
        projectView.delegate = self
        self.view.addSubview(projectView)
    }
    
    // MARK: Bottom Views
    
    func setupBottomViews() {
        let scale = ScreenWidth / frontImageView.frame.width * 2
        
        self.backImageView.frame = CGRectMake(0 - (backImageView.frame.width * scale / 2), ScreenHeight - backImageView.frame.height * scale, backImageView.frame.width * scale, backImageView.frame.height * scale)
        self.view.addSubview(self.backImageView)
        
        self.frontImageView.frame = CGRectMake(0, ScreenHeight - frontImageView.frame.height * scale, frontImageView.frame.width * scale, frontImageView.frame.height * scale)
        self.view.addSubview(self.frontImageView)
    }
    
    func startAnimateBackWave() {
        let scale = ScreenWidth / frontImageView.frame.width * 2
        
        UIView.animateWithDuration(5, delay: 0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {
            self.backImageView.frame.origin.x = 0
        }, completion: { (success: Bool) in
            self.backImageView.frame.origin.x = 0 - (self.backImageView.frame.width * scale / 2)
        })
    }
    
    func startAnimateFrontWave() {
        UIView.animateWithDuration(5, delay: 0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {
            self.frontImageView.frame.origin.x = 0 - self.frontImageView.frame.width / 2
        }, completion: { (success: Bool) in
            self.frontImageView.frame.origin.x = 0
        })
    }
    
    // MARK: Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Project", forIndexPath: indexPath) as! ProjectCell
        
        let project = projects[indexPath.row]
        cell.titleLabel.text = project.name
        cell.imageView.image = UIImage(data: project.photoData)
        
        if indexPath.row < timeCache.count {
            cell.timeLabel.text = timeCache[indexPath.row] as? String
        } else {
            let timeInterval = abs(project.lastModified.timeIntervalSinceNow)
            if timeInterval < 60 {
                cell.timeLabel.text = "\(Int(round(timeInterval))) sec ago"
            } else if timeInterval / 60 < 60 {
                cell.timeLabel.text = "\(Int(round(timeInterval / 60))) min ago"
            } else if timeInterval / 3600 < 24 {
                cell.timeLabel.text = "\(Int(round(timeInterval / 3600))) hr ago"
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                cell.timeLabel.text = dateFormatter.stringFromDate(project.lastModified)
            }
            timeCache[indexPath.row] = cell.timeLabel.text!
        }
        cell.tag = indexPath.row
        cell.delegate = self
        
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowOffset = CGSizeMake(0, 0)
        cell.layer.shadowRadius = 5
        
        return cell
    }
    
    // MARK: Project cell delegate
    
    func deployTappedForCellAtIndexPath(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "Under Maintenance", message: "Try again later", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editTappedForCellAtIndexPath(indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("toProject", sender: self)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProject" {
            let controller = segue.destinationViewController as! ProjectViewController
            controller.project = projects[self.selectedRow]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        if NSJSONSerialization.isValidJSONObject(value) {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            } catch {
                print("error")
            }
        }
        return ""
    }

}

