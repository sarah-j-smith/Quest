//
//  RoomDetailController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 10/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

class RoomDetailController : NSViewController, NSTabViewDelegate, QuestController
{
    @IBOutlet var roomDetailObjectController : NSObjectController!
    @IBOutlet var tabView : NSTabView!
    
    var currentController : NSArrayController?

    var configureShouldBeEnabled = true
    var addShouldBeEnabled = true
    var removeShouldBeEnabled = true
    
    var exitsController : ExitsListViewController!
    
    @IBAction func returnToRoomList(sender: AnyObject)
    {
        let rvc = rootViewController()!
        rvc.switchToView(nil, transition: NSViewControllerTransitionOptions.SlideBackward)
    }
    
    override func viewDidLoad()
    {
        exitsController = ExitsListViewController(nibName: "ExitsListView", bundle: nil)!
        exitsController.bind("representedObject", toObject: roomDetailObjectController, withKeyPath: "selection", options: nil)
        let idx = tabView.indexOfTabViewItemWithIdentifier("Exits")
        let exitsTabViewItem = tabView.tabViewItems[idx] as NSTabViewItem
        exitsController.view.autoresizingMask = view.autoresizingMask
        exitsController.view.translatesAutoresizingMaskIntoConstraints = true
        let exitsTabView = exitsTabViewItem.view!
        var childFrame = exitsTabView.frame
        childFrame.origin = CGPointZero
        exitsController.view.frame = childFrame
        exitsTabView.addSubview(exitsController.view)
    }
    
    override func viewWillDisappear()
    {
        exitsController.unbind("representedObject")
    }
    
    deinit {
        NSLog("deinit RoomDetailController")
    }
    
    func addAction() -> Bool
    {
        if let tab = tabView.selectedTabViewItem
        {
            let tabName = tab.identifier as String
            switch tabName {
                case "exits" :
                    exitsController.addExit()
                default:
                    NSLog("")
            }
        }
        return true
    }
    
    func removeAction() -> Bool
    {
        if let tab = tabView.selectedTabViewItem
        {
            let tabName = tab.identifier as String
            switch tabName {
            case "exits" :
                exitsController.removeExit()
            default:
                NSLog("")
            }
        }
        return true
    }
}