//
//  StateDetailTableViewController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import Firebase

class StateDetailTableViewController: UITableViewController {
    
    var state: String?
    
    var rooms: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = state
        getRooms()
        RoomController.observeChangesForState(state!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getRooms), name: "roomsUpdated", object: nil)
        
        RoomController.observeChangesForState(state!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getRooms() {
        guard let state = state else { return }
        RoomController.getRoomsForState(state) { (rooms) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let rooms = rooms else { return }
                self.rooms = rooms
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rooms.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("roomCell", forIndexPath: indexPath)
        cell.textLabel?.text = rooms[indexPath.row]
        
        
        return cell
    }
    
    @IBAction func newPlaceButtonTapped(sender: AnyObject) {
        var placeTextField: UITextField?
        
        
        let alert = UIAlertController(title: "Add New Place", message: "Please enter a new place to add to the GlobaLocal Database", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            placeTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            placeTextField?.resignFirstResponder()
            guard let text = placeTextField?.text, state = self.state else { return }
            RoomController.addNewRoomToState(state, newRoom: text, completion: { (success) in
                if success {
                    self.tableView.reloadData()
                }
            })
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
