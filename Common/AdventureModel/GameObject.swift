////
//  GameObject.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 24/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class GameObject : NSObject, NSCoding, Printable
{
    /** System name, must be unique; must have no spaces and be URL fragment safe */
    var objectName : String
    
    /** User visible descriptive name */
    var visibleName = "thing"
    
    override var description : String {
        get {
            return "Room: [\(objectName)] \(visibleName)"
        }
    }
    
    convenience init( objectName: String )
    {
        self.init(name:objectName, descriptiveName:objectName)
    }
    
    init( name: String, descriptiveName: String )
    {
        self.objectName = name
        self.visibleName = descriptiveName
    }
    
    required init(coder aDecoder: NSCoder)
    {
        objectName = aDecoder.decodeObjectForKey("objectName") as String!
        visibleName = aDecoder.decodeObjectForKey("visibleName") as String!
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(objectName, forKey: "objectName")
        aCoder.encodeObject(visibleName, forKey: "visibleName")
    }
}
