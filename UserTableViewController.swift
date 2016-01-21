//
//  UserTableViewController.swift
//  ParseStarterProject
//
//  Created by Yeswanth varma Kanumuri on 1/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI




class UserTableViewController: UITableViewController ,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
   
    
    var usernames = [String]()
    
    var recipientUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkForMessage"), userInfo: nil, repeats: true)
        
        var query = PFUser.query()!
        query.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
        var users = query.findObjects()
        
        for user in users as! [PFUser] {
            
            usernames.append(user.username!)
            
        }
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.recipientUsername = usernames[indexPath.row]
        
        var image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var iamgeTosend = PFObject(className: "image")
        
        
        iamgeTosend["photo"] = PFFile(name: "photo.jpg", data: UIImageJPEGRepresentation(image, 0.5)!)
        
        
        iamgeTosend["senderUsername"] = PFUser.currentUser()?.username!
        
        iamgeTosend["recipientUsername"] = self.recipientUsername
        
        
        let acl = PFACL()
        
        acl.setPublicReadAccess(true)
        
        acl.setPublicWriteAccess(true)
        
        iamgeTosend.ACL = acl
        
        
        iamgeTosend.saveInBackground()
        
     
        
    }
    
    
    func checkForMessage () {
    
    
    
    print("checked")
        
    var query = PFQuery(className: "image")
        
       query.whereKey("recipientUsername", equalTo: (PFUser.currentUser()?.username)!)
        
        var images = query.findObjects()
        
        
        if let pfObjects = images as? [PFObject] {
        
        print(pfObjects)
            
            
            if pfObjects.count > 0 {
            
            var imageView : PFImageView = PFImageView()
            
            imageView.file = pfObjects[0]["photo"] as? PFFile
             
                
             imageView.loadInBackground({ (photo, error) -> Void in
                
                
                if error == nil {
                
                
                var senderUsername = "Unknown user"
                    
                    
                    if let username = pfObjects[0]["senderUsername"] as? String {
                    
                    senderUsername = username
                    
                    
                    
                    
                    }
                    
                    
                    let alert : UIAlertController = UIAlertController(title: "message", message: "form \(senderUsername)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        
                        
                        let backgroundView:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                        
                        
                        backgroundView.backgroundColor = UIColor.blackColor()
                        
                        backgroundView.alpha = 0.8
                        
                        
                        backgroundView.tag = 10
                        
                        backgroundView.contentMode = UIViewContentMode.ScaleAspectFit
                        
                        self.view.addSubview(backgroundView)
                        
                        

                        
                        
                        let displayedImage:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                        
                        
                        displayedImage.image = photo
                        
                        displayedImage.tag = 10
                        
                        displayedImage.contentMode = UIViewContentMode.ScaleAspectFit
                        
                        self.view.addSubview(displayedImage)
                        
                        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("hideMessage"), userInfo: nil, repeats: false)
                        
                        pfObjects[0].delete()
                        
                        
                    }))
                    
                    
                self.presentViewController(alert, animated: true, completion: nil)
                
                }
                
                
                
                
                
             })
                
            
        
            }
        
        }
    
    }
    
    func hideMessage () {
    
    
        for subview in self.view.subviews {
        
        
            if subview.tag == 10 {
            
            
            subview.removeFromSuperview()
            
            }
        
        
        
        
        }
    
    
    
    
    
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout" {
            
           PFUser.logOutInBackgroundWithBlock() { (error) -> Void in
            
            
            if error != nil {
                
                print("logout fail")
                print(error)
            
            
            } else {
                
                print("logout success")
            }
            
            
            }
            
            
           
            
            
        }
        
    }
    
    
}