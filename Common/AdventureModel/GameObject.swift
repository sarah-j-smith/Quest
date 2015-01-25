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
    var objectKey : String {
        didSet {
            NSLog("objectKey: \(objectKey)")
        }
    }
    
    /** User visible descriptive name */
    var objectName : String {
        didSet {
            NSLog("objectName: \(objectName)")
        }
    }
    
    var parentName : String?
    
    override var description : String {
        get {
            return "Object: [\(objectKey)] \(objectName)"
        }
    }
    
    convenience init(objectName name: String )
    {
        let allNameChars = NSRange(location: 0, length: countElements(name))
        let validCharsRegex = NSRegularExpression(pattern: "[\\P{L}]", options: nil, error: nil)!
        let key = validCharsRegex.stringByReplacingMatchesInString(name, options: nil, range: allNameChars, withTemplate: "-")

        self.init(objectKey:name.keySafe(), objectName:name)
    }
    
    init(objectKey key: String, objectName name: String )
    {
        self.objectKey = key
        self.objectName = name
    }
    
    required init(coder aDecoder: NSCoder)
    {
        objectKey = aDecoder.decodeObjectForKey("objectKey") as String!
        objectName = aDecoder.decodeObjectForKey("objectName") as String!
        parentName = aDecoder.decodeObjectForKey("parentName") as String!
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(objectKey, forKey: "objectKey")
        aCoder.encodeObject(objectName, forKey: "objectName")
        aCoder.encodeObject(parentName, forKey: "parentName")
    }
}
