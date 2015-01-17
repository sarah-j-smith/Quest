//
//  NSViewController+Quest.swift
//  Quest
//
//  Created by Sarah Smith on 12/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

extension NSViewController
{
    func rootViewController() -> RootViewController?
    {
        var prev = self
        var pvc = self.parentViewController
        while pvc != nil
        {
            prev = pvc!
            pvc = pvc!.parentViewController
        }
        return prev as? RootViewController
    }
}