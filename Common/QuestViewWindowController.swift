//
//  QuestViewWindowController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 6/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

let QuestViewWindowControllerDidLoad = "QuestViewWindowControllerDidLoad"
let QuestViewWindowControllerWillClose = "QuestViewWindowControllerWillClose"

class QuestViewWindowController : NSWindowController, NSWindowDelegate
{
    @IBOutlet var questViewController : QuestView!
    
    @IBAction func stopPlay(sender: AnyObject)
    {
        dismissController(sender)
    }
    
    override func windowDidLoad()
    {
        let notifier = NSNotificationCenter.defaultCenter()
        notifier.postNotificationName(QuestViewWindowControllerDidLoad, object: self, userInfo: nil)
    }
    
    func windowWillClose(notification: NSNotification) {
        let notifier = NSNotificationCenter.defaultCenter()
        notifier.postNotificationName(QuestViewWindowControllerWillClose, object: self, userInfo: nil)
    }
}