//
//  RoomDetails.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 24/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class RoomDetails : NSObject, NSCoding, Printable
{
    dynamic var roomKey = "Unnamed-Room"
    dynamic var roomDescription = "Nothing special"
    dynamic var objects = [ GameObject ]()
    dynamic var exits = [ LinkDescription ]()
    
    override init() {
        super.init()
        //
    }
    
    required init(coder aDecoder: NSCoder)
    {
        roomKey = aDecoder.decodeObjectForKey("roomKey") as String
        roomDescription = aDecoder.decodeObjectForKey("roomDescription") as String
        objects = aDecoder.decodeObjectForKey("objects") as [ GameObject ]
        exits = aDecoder.decodeObjectForKey("exits") as [ LinkDescription ]
        super.init()
        NSLog("RoomDetails - initWithCoder - loaded \(roomKey)")
        NSLog("    \(roomDescription)")
        NSLog("    \(objects.count) objects")
        NSLog("    \(exits.count) exits")
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(roomKey, forKey: "roomKey")
        aCoder.encodeObject(roomDescription, forKey: "roomDescription")
        aCoder.encodeObject(objects, forKey: "objects")
        aCoder.encodeObject(exits, forKey: "exits")
        NSLog("RoomDetails - encodeWithCoder - stored \(roomKey)")
        NSLog("    \(objects.count) objects")
        NSLog("    \(exits.count) exits")
    }

    func objectForKey(keyName: String) -> GameObject?
    {
        for obj in objects
        {
            if obj.objectName == keyName
            {
                return obj
            }
        }
        return nil
    }
    
    func isCurrentRoom() -> Bool
    {
        if let _ = objectForKey("Player")
        {
            return true
        }
        return false
    }
}
