//
//  RootViewController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 3/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

var QuestControllerObservingCtx = 0

class RootViewController : NSViewController
{
    @IBOutlet var gameStateViewController : GameStateViewController!
//    @IBOutlet var roomsListViewController : RoomListViewController!
//    @IBOutlet var roomDetailViewController : RoomDetailController!
    
    @IBOutlet var backButton : NSButton!
    @IBOutlet var drillDownButton : NSButton!
    @IBOutlet var configureButton : NSButton!
    @IBOutlet var playButton : NSButton!
    @IBOutlet var addButton : NSButton!
    @IBOutlet var removeButton : NSButton!
    @IBOutlet var contentPane : NSView!
    
    var currentViewController : NSViewController!

    var viewStack = [ NSViewController ]()
    var observedViewControllers = [ NSViewController ]()
    
    var questWindow = QuestViewWindowController(windowNibName: "QuestView")

    @IBAction func goBack(sender: AnyObject)
    {
        switchToView(nil, transition: NSViewControllerTransitionOptions.SlideBackward)
    }
    
    @IBAction func playGame(sender: AnyObject)
    {
        if let gs = gameStateViewController.representedObject as? GameState
        {
            if gs.rooms.count > 0
            {
                questWindow.showWindow(self)
                // once the window is loaded, it calls back here to the "loadGame" 
                // function to actually set up the game structure in the window
            }
        }
    }
    
    @IBAction func addButton(sender: AnyObject)
    {
        if let vc = currentViewController as? QuestController
        {
            vc.addAction?()
        }
    }
    
    @IBAction func removeButton(sender: AnyObject)
    {
        if let vc = currentViewController as? QuestController
        {
            vc.removeAction?()
        }
    }
    
    @IBAction func drillDownButton(sender: AnyObject)
    {
        if let vc = currentViewController as? QuestController
        {
            vc.drillDownAction?()
        }
    }
    
    @IBAction func configureButton(sender: AnyObject)
    {
        if let vc = currentViewController as? QuestController
        {
            vc.configureAction?()
        }
    }
    
    func loadGame(notification: NSNotification)
    {
        NSLog("Got loadGame notification")
        if let gsObject: AnyObject = gameStateViewController.gameStateObjectController.content
        {
            let gs = gsObject as GameState
            let data = NSKeyedArchiver.archivedDataWithRootObject(gs)
            let qv = questWindow.questViewController
            qv.model = NSKeyedUnarchiver.unarchiveObjectWithData(data) as GameState
            if qv.currentRoom == nil
            {
                for rm in qv.model.rooms
                {
                    if rm.details.isCurrentRoom()
                    {
                        qv.currentRoom = rm
                        break
                    }
                }
            }
            if qv.currentRoom == nil
            {
                qv.currentRoom = qv.model.rooms.first
            }
            qv.refreshView()
        }
        else
        {
            NSLog("Cannot play game when Game State not yet set up")
        }
    }
    
    func quitGame(notification: NSNotification)
    {
        NSLog("Game editor notified of player quit")
    }
    
    @IBAction func editRoom(sender: AnyObject)
    {
        NSLog("editRoom")
//        let rlc = currentViewController as RoomListViewController
//        let maybeRoom: AnyObject = rlc.roomArrayController.selection
//        if let room = maybeRoom as? Room
//        {
//            NSLog("room: \(room) -- \(room.roomKey)")
//        }
//        switchToView(roomDetailViewController, transition: NSViewControllerTransitionOptions.SlideForward)
    }
    
    override func viewWillDisappear()
    {
        let notifier = NSNotificationCenter.defaultCenter()
        notifier.removeObserver(self)
        stopObservingQuestController(currentViewController)
    }
    
    override func viewDidLoad()
    {
        let notifier = NSNotificationCenter.defaultCenter()
        notifier.addObserver(self, selector: Selector("loadGame:"), name: QuestViewWindowControllerDidLoad, object: questWindow)
        notifier.addObserver(self, selector: Selector("quitGame:"), name: QuestViewWindowControllerWillClose, object: questWindow)

        view.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable | NSAutoresizingMaskOptions.ViewWidthSizable
        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.addSubview(gameStateViewController.view)
        gameStateViewController.view.autoresizingMask = view.autoresizingMask
        
        var childFrame = view.frame
        childFrame.origin = CGPointZero
        gameStateViewController.view.frame = childFrame
        
        currentViewController = gameStateViewController
        
        addChildViewController(gameStateViewController)
        startObservingQuestController(gameStateViewController)
        
        backButton.enabled = false
        playButton.enabled = true
    }
    
    func switchToView(newViewController: NSViewController?, transition: NSViewControllerTransitionOptions)
    {
        var previousViewController = currentViewController!
        stopObservingQuestController(previousViewController)
        if (transition == NSViewControllerTransitionOptions.SlideBackward)
        {
            assert(newViewController == nil, "Ignoring newViewController when popping back!")
            assert(viewStack.count > 0)
            currentViewController = viewStack.removeLast()
        }
        else
        {
            viewStack.append(currentViewController!)
            currentViewController = newViewController
        }
        currentViewController.view.autoresizingMask = view.autoresizingMask
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = true
        var childFrame = view.frame
        childFrame.origin = CGPointZero
        currentViewController!.view.frame = childFrame
        transitionFromViewController(previousViewController, toViewController: currentViewController!,
            options: transition, completionHandler: {() -> Void in
                NSLog("Completed!!")
        })
        startObservingQuestController(currentViewController)
        updateButtonState()
    }
    
    func updateButtonState()
    {
        // By default all buttons are disabled.
        backButton.enabled = (viewStack.count > 0)
        drillDownButton.enabled = false
        configureButton.enabled = false
        addButton.enabled = false
        removeButton.enabled = false
        if let questViewController = currentViewController as? QuestController
        {
            // If the view controller implements the QuestController protocol, then 
            // check for presence of the optional protocol vars for each button.
            if let drillDownEnabled = questViewController.drillDownShouldBeEnabled
            {
                // If the protocol var is present set the button's enabled flag to it.
                drillDownButton.enabled = drillDownEnabled
            }
            if let configureEnabled = questViewController.configureShouldBeEnabled
            {
                configureButton.enabled = configureEnabled
            }
            if let addEnabled = questViewController.addShouldBeEnabled
            {
                addButton.enabled = addEnabled
            }
            if let removeEnabled = questViewController.removeShouldBeEnabled
            {
                removeButton.enabled = removeEnabled
            }
        }
    }
    
    func endEditing() -> Bool
    {
        let w = view.window!
        let editingEnded = w.makeFirstResponder(w)
        if !editingEnded
        {
            NSLog("Unable to end editing!")
            return false
        }
        return true
    }
    
// MARK: Key-Value Observing
    func startObservingQuestController(questController : NSViewController)
    {
        if let _ = find(observedViewControllers, questController)
        {
            NSLog("Already observed: %@", questController)
        }
        else
        {
            if questController is QuestController
            {
                questController.addObserver(self, forKeyPath: "drillDownShouldBeEnabled",
                    options: NSKeyValueObservingOptions.New, context: &QuestControllerObservingCtx)
                questController.addObserver(self, forKeyPath: "removeShouldBeEnabled",
                    options: NSKeyValueObservingOptions.New, context: &QuestControllerObservingCtx)
                observedViewControllers.append(questController)
            }
        }
    }
    
    func stopObservingQuestController(questController: NSViewController)
    {
        if let ix = find(observedViewControllers, questController)
        {
            questController.removeObserver(self, forKeyPath: "drillDownShouldBeEnabled",
                context: &QuestControllerObservingCtx)
            questController.removeObserver(self, forKeyPath: "removeShouldBeEnabled",
                context: &QuestControllerObservingCtx)
            observedViewControllers.removeAtIndex(ix)
        }
        else
        {
            NSLog("Not observed: %@", questController)
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if context != &QuestControllerObservingCtx
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        let changeKindInt = change[NSKeyValueChangeKindKey] as UInt
        let changeKind = NSKeyValueChange(rawValue: changeKindInt)
        if changeKind == NSKeyValueChange.Setting
        {
            let newValue = change[NSKeyValueChangeNewKey] as Bool
            if keyPath == "drillDownShouldBeEnabled"
            {
                drillDownButton.enabled = newValue
            }
            else if keyPath == "removeShouldBeEnabled"
            {
                removeButton.enabled = newValue
            }
        }
    }
}