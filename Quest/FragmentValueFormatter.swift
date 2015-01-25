//
//  FragmentValueFormatter.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 24/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class FragmentValueFormatter : NSFormatter
{
    override func stringForObjectValue(obj: AnyObject) -> String?
    {
         if let strObj = obj as? String
        {
            return strObj
        }
//        NSLog("stringForObjectValue Returning illegal! for \(obj)")
        return "illegal!"
    }
    
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>,
        forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool
    {
        obj.memory = string
        return true
    }
    
    override func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool
    {
        var outStr : String = ""
        var result = true
        for ch in partialString
        {
            var goodCh = ch
            if (!FragmentValueFormatter.isValidFragment(ch))
            {
                result = false
                goodCh = "-"
            }
            outStr.append(goodCh)
        }
        newString.memory = outStr
        return result
    }
    
    class func makeFragmentCompliant( name: String ) -> String
    {
        var outStr : String = ""
        for ch in name
        {
            var goodCh = ch
            if (!FragmentValueFormatter.isValidFragment(ch))
            {
                goodCh = "-"
            }
            outStr.append(goodCh)
        }
        return outStr
    }
    
    class func isValidFragment(ch: Character) -> Bool
    {
        return ((ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z") ||
            (ch >= "0" && ch <= "9") || (ch == "-") || (ch == "_") || (ch == "."))
        
    }
}