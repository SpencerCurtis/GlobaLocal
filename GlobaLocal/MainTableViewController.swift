//
//  MainTableViewController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomController.states.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = RoomController.states[indexPath.row]
        
        return cell
    }
    
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        
        UserController.signOutUser()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewControllerWithIdentifier("signupVC")
        self.presentViewController(signupVC, animated: true, completion: nil)
    }
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stateDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow, dvc = segue.destinationViewController as? StateDetailTableViewController else { return }
            let state = RoomController.states[indexPath.row]
            dvc.state = state
        }
        
    }
    
    
}
