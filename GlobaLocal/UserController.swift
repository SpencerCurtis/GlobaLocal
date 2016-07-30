//
//  UserController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/29/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit

class UserController {
    
    static func authenticateUser(completion: (success: Bool) -> Void) {
        guard let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey("loginDictionary") as? [String: String], email = userDictionary["email"], password = userDictionary["passsword"] else { completion(success: false); return }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            guard error == nil && user != nil else { completion(success: false); return }
            
        })
    }
    
    static func signUpAndSignInUser(email: String, password: String, username: String, viewController: UIViewController) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            guard error == nil else { print(error?.localizedDescription); return }
            
            guard let user = user else { return }
            FIRDatabase.database().reference().child("users").child(user.uid).setValue(["username": username] )
            
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                guard error == nil else { print(error?.localizedDescription); return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTVC = storyboard.instantiateViewControllerWithIdentifier("mainTableView")
                viewController.presentViewController(mainTVC, animated: true, completion: nil)
                let loginDictionary = ["email": email, "password": password]
                NSUserDefaults.standardUserDefaults().setValue(loginDictionary, forKey: "loginDictionary")
                
            })
        })
    }
    
    static func signInUser(email: String, password: String, viewController: UIViewController) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            let loginDictionary = ["email": email, "password": password]
            NSUserDefaults.standardUserDefaults().setValue(loginDictionary, forKey: "loginDictionary")
            
            guard error == nil else { print(error?.localizedDescription); return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTVC = storyboard.instantiateViewControllerWithIdentifier("mainTableView")
            viewController.presentViewController(mainTVC, animated: true, completion: nil)
            
        })
    }
    
    
}