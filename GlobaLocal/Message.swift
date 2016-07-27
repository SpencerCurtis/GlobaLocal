//
//  Message.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/27/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation

class Message {
    
    private let kSender = "name"
    private let kTimestamp = "timestamp"
    private let kBody = "body"
    
    let senderUsername: String
    let body: String
    let timestamp: NSTimeInterval
    
    init(roomNumber: String, senderUsername: String, body: String, timestamp: NSTimeInterval = NSDate().timeIntervalSince1970) {
        self.senderUsername = senderUsername
        self.body = body
        self.timestamp = timestamp
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let senderUsername = dictionary[kSender] as? String,
            body = dictionary[kBody] as? String,
            timestamp = dictionary[kTimestamp] as? Int else { return nil }
        self.senderUsername = senderUsername
        self.body = body
        self.timestamp = NSTimeInterval(timestamp)
    }
    
    var jsonValue: [String: AnyObject] {
        return [kSender: senderUsername.lowercaseString, kBody: body, kTimestamp: timestamp]
    }
}