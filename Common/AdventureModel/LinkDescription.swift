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
    dynamic var linkAct: String {
        didSet {
            NSLog("act: \(linkAct)")
        }
    }
    
    /** What is the destination of this link, eg "lounge-room" */
    dynamic var linkDest: String {
        didSet {
            NSLog("dest: \(linkDest)")
        }
    }
    
    /** What is the type of this link, by default "go" */
    dynamic var linkType: String {
        didSet {
            NSLog("type: \(linkType)")
        }
    }
    
    override var description : String {
        get {
            return "LinkDescription(act: \(linkAct), dest: \(linkDest), type: \(linkType))"
        }
    }
    
    class func safeMustacheKeys() -> NSSet
    {
        return NSSet(objects: "linkAct", "linkDest", "linkType" )
    }
    
    convenience override init() {
        self.init(act: "North", dest: "Room-Name", type: "Move")
    }
    
    init( act:String, dest:String, type:String)
    {
        linkAct = act
        linkDest = dest
        linkType = type
    }
    
    required init(coder aDecoder: NSCoder) {
        linkAct = aDecoder.decodeObjectForKey("linkAct") as String
        linkDest = aDecoder.decodeObjectForKey("linkDest") as String
        linkType = aDecoder.decodeObjectForKey("linkType") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(linkAct, forKey: "linkAct")
        aCoder.encodeObject(linkDest, forKey: "linkDest")
        aCoder.encodeObject(linkType, forKey: "linkType")
    }
}

