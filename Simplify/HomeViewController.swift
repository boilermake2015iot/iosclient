//
//  HomeViewController.swift
//  Simplify
//
//  Created by George Lo on 10/16/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit
import MRProgress

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ProjectCellDelegate {
    
    var collectionView: UICollectionView?
    let sunImageView = UIImageView(image: UIImage(named: "Sun"))
    let backImageView = UIImageView(image: UIImage(named: "BackWave"))
    let frontImageView = UIImageView(image: UIImage(named: "FrontWave"))
    
    var projects = [Project]()
    var timeCache = NSMutableArray()
    var selectedRow = Int()
    var animationStarted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveProjects", name: "SaveProjects", object: nil)
        
        self.view.backgroundColor = UIColor(red: 244.0/255, green: 240.0/255, blue: 236.0/255, alpha: 1)
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("Projects") as? NSData {
            self.projects = NSKeyedUnarchiver.unarchiveObjectWithData(object) as! [Project]
        }
        
        self.setupTopViews()
        self.setupMiddleViews()
        self.setupBottomViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive", name: "AppDidBecomeActive", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appWillResignActive", name: "AppWillResignActive", object: nil)
        
        self.appDidBecomeActive()
    }
    
    func appDidBecomeActive() {
        if animationStarted == false {
            animationStarted = true
            for var i = 0; i < projects.count; i++ {
                self.addTimeCacheForIndex(i)
            }
            
            self.startAnimateSun()
            self.startAnimateBackWave()
            self.startAnimateFrontWave()
        }
    }
    
    func appWillResignActive() {
        self.animationStarted = false
    }
    
    func saveProjects() {
        let object = NSKeyedArchiver.archivedDataWithRootObject(self.projects)
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: "Projects")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.timeCache.removeAllObjects()
        for var i = 0; i < projects.count; i++ {
            self.addTimeCacheForIndex(i)
        }
        self.collectionView?.reloadData()
    }
    
    func addTimeCacheForIndex(i: Int) {
        let project = projects[i]
        if project.deployTimes == 0 {
            timeCache[i] = "Never"
        } else {
            let timeInterval = abs(project.lastModified.timeIntervalSinceNow)
            if timeInterval < 60 {
                timeCache[i] = "\(Int(round(timeInterval))) sec ago"
            } else if timeInterval / 60 < 60 {
                timeCache[i] = "\(Int(round(timeInterval / 60))) min ago"
            } else if timeInterval / 3600 < 24 {
                timeCache[i] = "\(Int(round(timeInterval / 3600))) hr ago"
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                timeCache[i] = dateFormatter.stringFromDate(project.lastModified)
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        animationStarted = false
        timeCache.removeAllObjects()
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        addButton.addTarget(self, action: "addProject", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.frame = CGRectMake(ScreenWidth - 200, 50, 120, 100)
        addButton.setTitle("+ Add", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        addButton.titleLabel?.font = UIFont.boldSystemFontOfSize(30)
        self.view.addSubview(addButton)
    }
    
    func addProject() {
        let alertController = UIAlertController(title: "New Project", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField) in
            textField.placeholder = "Project Name"
        })
        alertController.addTextFieldWithConfigurationHandler({ (textField: UITextField) in
            textField.placeholder = "Image Name"
        })
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
            let projectName = alertController.textFields![0].text!
            let imageName = alertController.textFields![1].text!
            if projectName.characters.count == 0 {
                let alertController2 = UIAlertController(title: "Error", message: "Project Name and Image Name cannot be empty", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
                    self.addProject()
                })
                alertController2.addAction(okAction)
                self.presentViewController(alertController2, animated: true, completion: nil)
            } else {
                if let image = UIImage(named: imageName) {
                    self.projects.append(Project(name: projectName, deployTimes: 0, lastModified: NSDate(), photoData: UIImagePNGRepresentation(image)!))
                } else {
                    self.projects.append(Project(name: projectName, deployTimes: 0, lastModified: NSDate(), photoData: UIImagePNGRepresentation(UIImage(named: "DefaultImage")!)!))
                }
                let object = NSKeyedArchiver.archivedDataWithRootObject(self.projects)
                NSUserDefaults.standardUserDefaults().setObject(object, forKey: "Projects")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forRow: self.projects.count - 1, inSection: 0)])
                self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: self.projects.count - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
                
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
        self.collectionView = projectView
        self.view.addSubview(projectView)
    }
    
    // MARK: Bottom Views
    
    func setupBottomViews() {
        let scale = ScreenWidth / frontImageView.frame.width * 2
        
        self.backImageView.frame = CGRectMake(-1024, ScreenHeight - backImageView.frame.height * scale, 2048, backImageView.frame.height * scale)
        self.view.addSubview(self.backImageView)
        
        self.frontImageView.frame = CGRectMake(0, ScreenHeight - frontImageView.frame.height * scale, frontImageView.frame.width * scale, frontImageView.frame.height * scale)
        self.view.addSubview(self.frontImageView)
    }
    
    func startAnimateBackWave() {
        UIView.animateWithDuration(5, delay: 0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {
            self.backImageView.frame.origin.x = 0
        }, completion: { (success: Bool) in
            self.backImageView.frame.origin.x = -1024
        })
    }
    
    func startAnimateFrontWave() {
        UIView.animateWithDuration(5, delay: 0, options: [UIViewAnimationOptions.CurveLinear, UIViewAnimationOptions.Repeat], animations: {
            self.frontImageView.frame.origin.x = -1024
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
        
        if timeCache.count <= indexPath.row {
            self.addTimeCacheForIndex(indexPath.row)
        }
        cell.timeLabel.text = timeCache[indexPath.row] as? String
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
        DeployFactory.deploy(projects[indexPath.row], viewcontroller: self)
    }
    
    func editTappedForCellAtIndexPath(indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        self.performSegueWithIdentifier("toProject", sender: self)
    }
    
    func deleteTappedForCellAtIndexPath(indexPath: NSIndexPath) {
        let project = self.projects[indexPath.row]
        NSUserDefaults.standardUserDefaults().removeObjectForKey(project.name)
        self.projects.removeAtIndex(indexPath.row)
        let object = NSKeyedArchiver.archivedDataWithRootObject(self.projects)
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: "Projects")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.collectionView?.deleteItemsAtIndexPaths([indexPath])
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

}

