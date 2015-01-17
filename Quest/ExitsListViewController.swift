//
//  ExitsListViewController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 10/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

class ExitsListViewController : NSViewController
{
    @IBOutlet var exitsListArrayController : NSArrayController!
    @IBOutlet var exitsTableView : NSTableView!
    
    var currentlyEditedRow = -1
    var currentlyEditedColumn : String?
    
    func addExit()
    {
        let exit = exitsListArrayController.newObject() as LinkDescription
        exitsListArrayController.addObject(exit)
        exitsListArrayController.rearrangeObjects()
        let exitsSorted = exitsListArrayController.arrangedObjects as Array<LinkDescription>
        if let ix = find(exitsSorted, exit)
        {
            NSLog("Added exit at row \(ix)")
            exitsTableView.editColumn(0, row: ix, withEvent: nil, select: true)
            currentlyEditedRow = ix
            currentlyEditedColumn = "roomKey"
        }
    }
    
    func removeExit()
    {
        if let exit = exitsListArrayController.selection as? LinkDescription
        {
            exitsListArrayController.removeObject(exit)
        }
    }
}