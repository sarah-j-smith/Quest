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
    var gameName : String {
        didSet {
            NSLog("gameName: \(gameName)")
        }
    }
    
    var rooms : [ Room ] {
        didSet {
            NSLog("rooms array changed, from \(oldValue.count) > \(rooms.count) room/s")
        }
    }
    
    override var description : String {
        get {
            return "GameState: \(gameName)\n\(rooms)"
        }
    }
    
    override init()
    {
        gameName = "Game Title"
        rooms = [ Room() ]
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