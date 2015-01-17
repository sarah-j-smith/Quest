//
//  QuestController.swift
//  Quest
//
//  Created by Sarah Smith on 12/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

@objc protocol QuestController
{
    optional var drillDownShouldBeEnabled : Bool { get }
    optional var configureShouldBeEnabled : Bool { get }
    optional var addShouldBeEnabled : Bool { get }
    optional var removeShouldBeEnabled : Bool { get }
    
    optional func drillDownAction() -> Bool
    optional func configureAction() -> Bool
    optional func addAction() -> Bool
    optional func removeAction() -> Bool
}
