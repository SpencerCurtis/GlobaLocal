//
//  ChatViewController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var state: String?
    var room: String?
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomToolbarConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var toolbarTextField: UITextField!
    @IBOutlet weak var chatToolbar: UIToolbar!
    
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.estimatedRowHeight = 40
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.toolbarTextField.delegate = self
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        //        self.chatToolbar.removeFromSuperview()
        
        guard let state = state, room = room else { return }
        let roomMessagesRef = FIRDatabase.database().reference().child("messages").child(state).child(room)
        roomMessagesRef.observeEventType(.Value, withBlock: { (snapshot) in
            
            var messageArray: [Message] = []
            guard let messages = snapshot.value as? [String: [String: AnyObject]] else { return }
            for message in messages {
                
                guard let msg = Message(dictionary: message.1) else { print("Parsed snapshot wrong for creating a message"); return }
                messageArray.append(msg)
                
            }
            MessageController.messages = messageArray.sort({$0.timestamp < $1.timestamp})
            self.chatTableView.reloadData()
            
        })
        self.toolbarBottomConstraintInitialValue = 0
        
        //        enableKeyboardHideOnTap()
        
    }
    
    
    @IBAction func sendMessageButtonTapped(sender: AnyObject) {
        guard let state = state, room = room, text = toolbarTextField.text, user = FIRAuth.auth()?.currentUser else { return }
        FIRDatabase.database().reference().child("users").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            let username = dict["username"] as! String
            MessageController.sendMessage(state, room: room, username: username, messageText: text)
        })
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        guard let state = state, room = room else { return }
        let roomMessagesRef = FIRDatabase.database().reference().child("messages").child(state).child(room)
        roomMessagesRef.removeAllObservers()
        MessageController.messages = []
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        let message = MessageController.messages[indexPath.row]
        cell.updateWithMessage(message)
        
        return cell
    }
    
}
