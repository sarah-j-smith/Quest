//
//  Room.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 3/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation

class Room : NSObject, NSCoding, Printable
{
    dynamic var roomKey = "Unnamed-Room"
    dynamic var roomName = "Unnamed Room"
    
    var details = RoomDetails()

    override var description : String {
        get {
            return "Room: [\(roomKey)] \(roomName) - \"\(details.roomDescription)\""
        }
    }
    
    func copyWithZone(zone: NSZone) -> Room
    {
        NSLog("Room copyWithZone")
        return Room(key: self.roomKey, name: self.roomName)
    }

    convenience override init()
    {
        self.init(key:"Unnamed-Room", name:"Unnamed Room")
    }
    
    init(key: String, name: String)
    {
        roomKey = key
        roomName = name
        details = RoomDetails()
    }
    
    required init(coder aDecoder: NSCoder) {
        roomKey = aDecoder.decodeObjectForKey("roomKey") as String
        roomName = aDecoder.decodeObjectForKey("roomName") as String
        details = aDecoder.decodeObjectForKey("details") as RoomDetails
    }
    
    convenience init(name: String)
    {
        let len = countElements(name)
        if (len == 0)
        {
            fatalError("Cannot create room with empty name")
        }
        let allNameChars = NSRange(location: 0, length: len)
        let validCharsRegex = NSRegularExpression(pattern: "[\\P{L}]", options: nil, error: nil)!
        let key = validCharsRegex.stringByReplacingMatchesInString(name, options: nil, range: allNameChars, withTemplate: "-")
        self.init(key: key, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(roomKey, forKey: "roomKey")
        aCoder.encodeObject(roomName, forKey: "roomName")
        aCoder.encodeObject(details, forKey: "details")
    }
}