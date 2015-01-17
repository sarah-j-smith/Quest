//
//  GameStateViewController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 2/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

var GameStateObservingCtx = 0

/** The root view controller for the game editor */
class GameStateViewController : NSViewController, NSTextFieldDelegate, QuestController
{
    @IBOutlet var gameStateObjectController : NSObjectController!
    
    @IBOutlet var gameTitleTextField : NSTextField!
    @IBOutlet var gameTitleLabel : NSTextField!
    @IBOutlet var gameTitleBox : NSView!
    @IBOutlet var editTitleButton : NSButton!
    
    @IBOutlet var editGameButton: NSButton!
    
    var isObserved = false
    var boundViewController : NSViewController?
    var bindingPath : String!
    
    deinit {
        NSLog("deinit GameStateViewController")
    }
    
    override func viewDidLoad()
    {
        gameTitleTextField.hidden = true
        startObserving()
    }
    
    override func viewWillDisappear()
    {
        stopObserving()
    }
    
    override func viewWillAppear() {
        if let bvc = boundViewController
        {
            bvc.unbind(bindingPath)
        }
    }
    
    @IBAction func editGameTitle(sender : AnyObject)
    {
        let w = view.window!
        if gameTitleTextField.hidden
        {
            gameTitleTextField.hidden = false
            w.makeFirstResponder(gameTitleTextField)
        }
        else
        {
            gameTitleTextField.hidden = true
            editTitleButton.state = NSOffState
            w.makeFirstResponder(view)
        }
    }
    
    @IBAction func editingFinished(sender : AnyObject)
    {
        gameTitleTextField.hidden = true
        editTitleButton.state = NSOffState
        let w = view.window!
        w.makeFirstResponder(view)
    }
    
    @IBAction func editGame(sender : AnyObject)
    {
        let rvc = rootViewController()!
        NSLog("Creating RoomListViewController")
        let roomListViewController = RoomListViewController(nibName:"RoomListView", bundle: nil)!
        NSLog("About to switch to view")
        bindViewController(roomListViewController, binding: "selection")
        rvc.addChildViewController(roomListViewController)
        rvc.switchToView(roomListViewController, transition: NSViewControllerTransitionOptions.SlideForward)
    }
    
    func bindViewController(viewController: NSViewController, binding: String)
    {
        boundViewController = viewController
        bindingPath = binding
        NSLog("Binding representedObject")
        viewController.bind("representedObject", toObject:gameStateObjectController,
            withKeyPath:binding, options: nil)
    }
    
    func unbindViewController()
    {
        if let bvc = boundViewController
        {
            bvc.unbind(bindingPath)
            boundViewController = nil
        }
    }
    
// MARK: QuestController compliance
    
    var drillDownShouldBeEnabled = true
    var configureShouldBeEnabled = true
    
    func drillDownAction() -> Bool
    {
        editGame(self)
        return true
    }
    
    func configureAction() -> Bool
    {
        editGameTitle(self)
        return true
    }
    
    // MARK: Observing
    
    func startObserving()
    {
        if isObserved
        {
            NSLog("Game already observed")
        }
        else
        {
            self.addObserver(self, forKeyPath: "representedObject.gameName",
                options: NSKeyValueObservingOptions.Old, context: &GameStateObservingCtx)
            isObserved = true
        }
    }
    
    func stopObserving()
    {
        if isObserved
        {
            self.removeObserver(self, forKeyPath: "representedObject.gameName", context: &GameStateObservingCtx)
            isObserved = false
        }
        else
        {
            NSLog("Cannot stop observing - not listed as observed")
        }
    }
    
    func change(keyPath : String, ofObject object: NSObject, toValue: AnyObject?)
    {
        NSLog("Changed object: \(object) to be \(toValue)")
        object.setValue(toValue, forKeyPath: keyPath)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        if (context != &GameStateObservingCtx)
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        var oldValue: NSObject? = change[NSKeyValueChangeOldKey] as? NSObject
        if (oldValue == NSNull())
        {
            NSLog("GameState oldValue is nil")
            oldValue = nil
        }
        else
        {
            if let oldNameStr = oldValue as? String
            {
                if let gameState = gameStateObjectController.content as? GameState
                {
                    if oldNameStr != gameState.gameName
                    {
                        NSLog("Game name changed from \(oldNameStr) to \(gameState.gameName)")
                        let undo = self.undoManager!
                        undo.prepareWithInvocationTarget(self).change(keyPath, ofObject: object as NSObject, toValue: oldValue)
                        undo.setActionName("Edit Name")
                    }
                }
            }
        }
    }

}