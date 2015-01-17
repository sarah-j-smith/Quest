//
//  GameState.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 2/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation

class GameState : NSObject, NSCoding, Printable
{
    var gameName = "Game Title"
    
    var rooms = [ Room() ]
    
    override var description : String {
        get {
            return "GameState: \(gameName)\n\(rooms)"
        }
    }
    
    override init()
    {
        super.init()
        rooms[0].details = RoomDetails()
        rooms[0].details.objects.append(GameObject(objectName: "Player"))
    }
    
    required init(coder aDecoder: NSCoder)
    {
        gameName = aDecoder.decodeObjectForKey("gameName") as String
        rooms = aDecoder.decodeObjectForKey("rooms") as [ Room ]
//        NSLog("Loaded \"\(gameName)\" with \(rooms.count) rooms")
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(gameName, forKey: "gameName")
        aCoder.encodeObject(rooms, forKey: "rooms")
//        NSLog("Encoded \"\(gameName)\" with \(rooms.count) rooms")
    }

}