//
//  LoginViewController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        guard let email = emailTextField.text where ((emailTextField.text?.containsString("@")) != nil), let password = passwordTextField.text else { return }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            guard error == nil else { print(error?.localizedDescription); return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTVC = storyboard.instantiateViewControllerWithIdentifier("mainTableView")
            self.presentViewController(mainTVC, animated: true, completion: nil)
            
        })
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
