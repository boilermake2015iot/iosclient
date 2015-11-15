//
//  DeployFactory.swift
//  Simplify
//
//  Created by George Lo on 10/18/15.
//  Copyright © 2015 BoilerMakeIOT. All rights reserved.
//

import UIKit
import MRProgress

class DeployFactory: NSObject {
    class func deploy(project: Project, viewcontroller: UIViewController) {
        project.lastModified = NSDate()
        project.deployTimes++
        NSNotificationCenter.defaultCenter().postNotificationName("SaveProjects", object: nil)
        let key = project.name
        let data = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData
        
        func displayErrorMessage() {
            let alertController = UIAlertController(title: "Error", message: "No Data in this project", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            viewcontroller.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if data == nil {
            displayErrorMessage()
        } else {
            let bricks = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Brick]
            if bricks.count == 0 {
                displayErrorMessage()
            }
            var jsonString = JSONFactory.getJSONStringForBricks(bricks)
            jsonString = jsonString.stringByReplacingOccurrencesOfString("\\\"", withString: "\"")
            print(jsonString)
            
            let overlayView = MRProgressOverlayView.showOverlayAddedTo(viewcontroller.view, title: "Executing", mode: .Indeterminate, animated: true)
            let post = jsonString
            let postData = post.dataUsingEncoding(NSASCIIStringEncoding)
            let postLength = "\(jsonString.characters.count)"
            let request = NSMutableURLRequest()
            request.URL = NSURL(string: SERVERURL)
            request.HTTPMethod = "POST"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) in
                var fail = true
                if data != nil {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                    if let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if dict.objectForKey("success") != nil {
                            fail = false
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if fail == true {
                        overlayView.titleLabelText = "Failed"
                        overlayView.mode = MRProgressOverlayViewMode.Cross
                    } else {
                        overlayView.titleLabelText = "Success"
                        overlayView.mode = MRProgressOverlayViewMode.Checkmark
                    }
                })
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    overlayView.dismiss(true)
                })
            })
            task.resume()
        }
    }
}
