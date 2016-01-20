//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var Username: UITextField!
    

    
    
    @IBAction func LogInSignUp(sender: AnyObject) {
        
        
        PFUser.logInWithUsernameInBackground(Username.text!, password:Username.text!) {
            
            (user: PFUser?, error: NSError?) -> Void in
            
            if let error = error {
                
                var user = PFUser()
                user.username = self.Username.text!
                user.password = self.Username.text!
                
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    
                    if let error = error {
                        
                        let errorString = error.userInfo["error"]! as! String
                        
                        self.errorMsg.text = "Error: " + errorString
                        
                    } else {
                        
                        print("Signed Up")
                        self.performSegueWithIdentifier("ShowUserTable", sender: self)
                        
                    }
                    
                    
                }
                
            } else {
                
                print("Logged In")
                self.performSegueWithIdentifier("ShowUserTable", sender: self)
            }
            
            
        }
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBar.hidden = true
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
            
            self.performSegueWithIdentifier("ShowUserTable", sender: self)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}