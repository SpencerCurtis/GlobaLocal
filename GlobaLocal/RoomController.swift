//
//  RoomController.swift
//  GlobaLocal
//
//  Created by Spencer Curtis on 7/22/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import Firebase

class RoomController {
    
    static let allStatesRef = FIRDatabase.database().reference().child("state")
    
    static let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    
    
    static var rooms: [String] = []
    
    static func getRoomsForState(state: String, completion: (rooms: [String]?) -> Void) {
        let stateRef = allStatesRef.child(state)
        stateRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            guard let places = snapshot.value as? [String: AnyObject] else { return }
            let placeArray = places.map({$0.0})
            self.rooms = placeArray
            completion(rooms: placeArray)
        })
    }
    
    static func addNewRoomToState(state: String, newRoom: String, completion: (success: Bool) -> Void) {
        
        if self.rooms.contains(newRoom) {
            completion(success: false)
            // Alert saying this room is already made
        } else {
            
            let stateRef = allStatesRef.child(state)
            stateRef.child(newRoom).setValue(true)
            rooms.append(newRoom)
            completion(success: true)
        }
    }
    
    
    static func observeChangesForState(state: String) {
        let stateRef = allStatesRef.child(state)
        stateRef.observeEventType(.Value, withBlock: { (_) in
            NSNotificationCenter.defaultCenter().postNotificationName("roomsUpdated", object: nil)
        })
    }
    
}