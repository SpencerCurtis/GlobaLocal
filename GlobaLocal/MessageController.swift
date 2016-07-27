//
//  MessageController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import Firebase

class MessageController {
    
    static let ref = FIRDatabase.database().reference()
    static let roomRef = ref.child("rooms")
    static let messagesRef = ref.child("messages")
    static let chatMembersRef = ref.child("chatMembers")
    
    static func sendMessage(room: String, username: String, messageText: String) {
        let message = Message(roomNumber: room, senderUsername: username, body: messageText)
        messagesRef.child(room).childByAutoId().setValue(message.jsonValue)
        checkIfUserIsAlreadyInRoom(username, room: room) { (isInRoom) in
            if !isInRoom {
                chatMembersRef.child(room).child(username).setValue(true)
            }
        }
        
    }
    
    static func checkIfUserIsAlreadyInRoom(username: String, room: String, completion: (isInRoom: Bool) -> Void) {
        chatMembersRef.child(room).observeSingleEventOfType(.Value, withBlock: { snapshot in
            print(snapshot)
            guard snapshot.value?.valueForKey(username) as? Int == 1 else { completion(isInRoom: false); return }   
            completion(isInRoom: true)
        })
    }
    
}