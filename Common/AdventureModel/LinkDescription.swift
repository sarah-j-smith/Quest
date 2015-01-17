//
//  LinkDescription.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 23/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class LinkDescription : NSObject, NSCoding, GRMustacheSafeKeyAccess, Printable
{
    /** What action does this link represent, eg "Go to lounge" */
    var act: String
    
    /** What is the destination of this link, eg "lounge-room" */
    var dest: String
    
    /** What is the type of this link, by default "go" */
    var type: String
    
    override var description : String {
        get {
            return "LinkDescription(act: \(act), dest: \(dest), type: \(type))"
        }
    }
    
    class func safeMustacheKeys() -> NSSet
    {
        return NSSet(objects: "act", "dest", "type" )
    }
    
    init( act:String, dest:String, type:String)
    {
        self.act = act
        self.dest = dest
        self.type = type
    }
    
    required init(coder aDecoder: NSCoder) {
        act = aDecoder.decodeObjectForKey("act") as String
        dest = aDecoder.decodeObjectForKey("dest") as String
        type = aDecoder.decodeObjectForKey("type") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(act, forKey: "act")
        aCoder.encodeObject(dest, forKey: "dest")
        aCoder.encodeObject(type, forKey: "type")
    }
}

