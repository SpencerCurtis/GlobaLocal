//
//  ChatTableViewCell.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/28/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var messageLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var messageLabelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var usernameLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var usernameLabelTrailing: NSLayoutConstraint!
    
    
    func updateWithMessage(message: Message) {
        messageLabel.text = message.body
        usernameLabel.text = message.senderUsername
        
        if message.senderUsername == RoomController.username.lowercaseString {
            messageLabel.textAlignment = NSTextAlignment.Right
            messageLabelTrailing.constant = 8
            messageLabelLeading.constant = 167
            
            usernameLabel.textAlignment = NSTextAlignment.Right
            usernameLabelTrailing.constant = 8
            usernameLabelLeading.constant = 167
        } else {
            messageLabel.textAlignment = .Left
            usernameLabel.textAlignment = .Left
            messageLabel.backgroundColor = UIColor ( red: 0.0845, green: 0.6536, blue: 0.4883, alpha: 1.0 )
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
