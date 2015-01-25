//
//  StringFunctions.swift
//  Quest
//
//  Created by Sarah Smith on 24/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation

extension String {
    
    /** Returns a copy of this string with all non-letter characters replaced by "X" character.  This makes the string suitable for use as a URL fragment, and for use as a key in lookups. */
    func keySafe() -> String
    {
        var safeStr = ""
        var fillerChar : UnicodeScalar = "X"
        let fragmentChars = NSCharacterSet.URLFragmentAllowedCharacterSet()
        for uc in self.unicodeScalars
        {
            let uchar = uc.value as UTF32Char
            let safeCh = fragmentChars.longCharacterIsMember(uchar) ? uc : fillerChar
            safeStr.append(safeCh)
        }
        return safeStr
    }

    func fragmentEncode() -> String
    {
        if let result = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        {
            return result
        }
        return "XXXX-COULD-NOT-ENCODE-AS-FRAGMENT-XXXX"
    }
    
    func fragmentDecode() -> String
    {
        if let result = self.stringByRemovingPercentEncoding
        {
            return result
        }
        return "XXXX-COULD-NOT-DECODE-AS-FRAGMENT-XXXX"
    }
}
