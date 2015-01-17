//
//  RoomListViewController.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 3/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

var RoomsListObservingCtx = 0
var RoomObservingCtx = 0

class RoomListViewController : NSViewController, NSTableViewDelegate, NSTextFieldDelegate, QuestController
{
    @IBOutlet var tableView : NSTableView!
    @IBOutlet var roomArrayController : NSArrayController!
    
    var drillDownShouldBeEnabled = true
    var configureShouldBeEnabled = false
    var addShouldBeEnabled = true
    var removeShouldBeEnabled = true
    
    var currentlyEditedRow = -1
    var currentlyEditedColumn : String?
    
    var observedRooms = [ Room ]()
    
    var boundViewController : NSViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSLog("View did load")
    }
    
    override func viewDidAppear()
    {
        unbindViewController()
        
        super.viewDidAppear()
        NSLog("viewDidAppear")
        let w = tableView.window!
        w.makeFirstResponder(tableView)
        if let rooms = roomArrayController.arrangedObjects as? [ Room ]
        {
            if rooms.count > 0
            {
                if roomArrayController.selectedObjects.count == 0
                {
                    roomArrayController.setSelectionIndex(0)
                }
                NSLog("view appeared - got \(rooms.count) rooms")
            }
            else
            {
                NSLog("view appeared - rooms array empty")
            }
        }
        else
        {
            NSLog("view appeared - no rooms array on controller")
        }
        startObservingRepresentedObject()
    }
    
    override func viewWillDisappear()
    {
        super.viewWillDisappear()
        stopObservingRepresentedObject()
    }
    
    func bindViewController(viewController: NSViewController, binding: String)
    {
        boundViewController = viewController
        NSLog("Binding representedObject")
        viewController.bind("representedObject", toObject:roomArrayController,
            withKeyPath:binding, options: nil)
    }
    
    func unbindViewController()
    {
        if let bvc = boundViewController
        {
            bvc.unbind("representedObject")
            boundViewController = nil
        }
    }
    
    deinit {
        NSLog("deinit RoomListViewController")
    }
    
    @IBAction func editRoom(sender: AnyObject)
    {
        // Note: any button in an NSTableView has to be connected to its
        // table view delegate or it won't work
        NSLog("sender: \(sender)")
        let roomsListSorted = roomArrayController.arrangedObjects as Array<Room>
        let clickedRoom = sender as Room
        if let ix = find(roomsListSorted, clickedRoom)
        {
            NSLog("editRoom: \(clickedRoom) on row \(ix)")
            tableView.selectRowIndexes(NSIndexSet(index: ix), byExtendingSelection: false)
            let ok = roomArrayController.setSelectionIndex(ix)
            if !ok
            {
                NSLog("Could not select the row!!!")
            }
        }
        
        let rvc = rootViewController()!
        NSLog("Creating RoomDetailController")
        let roomDetailController = RoomDetailController(nibName: "RoomDetailView", bundle:nil)!
        bindViewController(roomDetailController, binding: "selection")
        NSLog("About to switch to view")
        rvc.addChildViewController(roomDetailController)
        rvc.switchToView(roomDetailController, transition: NSViewControllerTransitionOptions.SlideForward)
    }
    
    @IBAction func addRoom(sender: AnyObject)
    {
        let w = tableView.window!
        let editingEnded = w.makeFirstResponder(w)
        if !editingEnded
        {
            NSLog("Unable to end editing!")
            return
        }
        let undo = undoManager!
        if undo.groupingLevel > 0
        {
            undo.endUndoGrouping()
            undo.beginUndoGrouping()
        }
        let rm : Room = roomArrayController.newObject() as Room
        roomArrayController.addObject(rm)
        roomArrayController.rearrangeObjects()
        let roomsListSorted = roomArrayController.arrangedObjects as Array<Room>
        if let ix = find(roomsListSorted, rm)
        {
            NSLog("Starting edit on row \(ix)")
            tableView.editColumn(0, row: ix, withEvent: nil, select: true)
            currentlyEditedRow = ix
            currentlyEditedColumn = "roomKey"
        }
    }

    @IBAction func removeRoom(sender: AnyObject)
    {
        let ix = tableView.selectedRow
        let roomsListSorted = roomArrayController.arrangedObjects as Array<Room>
        if ix >= 0 && ix < roomsListSorted.count
        {
            roomArrayController.removeObjectAtArrangedObjectIndex(ix)
            roomArrayController.rearrangeObjects()
        }
        else
        {
            NSLog("Not removing as index \(ix) is outside valid indexes 0 - \(roomsListSorted.count - 1)")
        }
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        let col = tableView.selectedColumn
        let row = tableView.selectedRow
        NSLog("row \(currentlyEditedRow) -- col \(currentlyEditedColumn)")
        if let colCurrent = currentlyEditedColumn
        {
            if colCurrent == "roomKey"
            {
                if let str = fieldEditor.string
                {
                    let rooms = roomArrayController.content as [ Room ]
                    let rm = rooms[currentlyEditedRow]
                    NSLog("editor string >\(str)< --- visible name: >\(rm.roomName)<")
                    if rm.roomName == "Unnamed Room" && str != "" && str != "Unnamed-Room"
                    {
                        var newStr = ""
                        for ch in str
                        {
                            newStr.append(ch == "-" ? " " : ch)
                        }
                        willChange(NSKeyValueChange.Replacement, valuesAtIndexes: NSIndexSet(index: currentlyEditedRow), forKey: "rooms")
                        rm.roomName = newStr
                        rm.roomKey = str
                        didChange(NSKeyValueChange.Replacement, valuesAtIndexes: NSIndexSet(index: currentlyEditedRow), forKey: "rooms")
                    }
                }
            }
        }
        return true
    }
    
    func tableView(tableView: NSTableView, shouldEditTableColumn tableColumn: NSTableColumn?, row: Int) -> Bool
    {
        NSLog("tableView shouldEditTableColumn \(tableColumn)")
        if let tc = tableColumn
        {
            currentlyEditedColumn = tc.identifier
            currentlyEditedRow = row
            NSLog("should edit - row \(currentlyEditedRow) - col \(currentlyEditedColumn)")
        }
        return true
    }

// MARK: QuestController conformance
    
    func addAction() -> Bool
    {
        addRoom(self)
        return true
    }

    func removeAction() -> Bool
    {
        removeRoom(self)
        return true
    }
    
    func configureAction() -> Bool
    {
        return false
    }
    
// MARK: Key-value observing of Rooms
    
    func insertObject(object: Room, inRepresentedObjectAtIndex index: UInt)
    {
        NSLog("Inserting: \(object)")
    }
    
    func startObservingRepresentedObject()
    {
        addObserver(self, forKeyPath: "representedObject",
            options: NSKeyValueObservingOptions.Old, context: &RoomsListObservingCtx)
    }
    
    func stopObservingRepresentedObject()
    {
        removeObserver(self, forKeyPath: "representedObject", context: &RoomsListObservingCtx)
    }
    
    func refreshRoomObserving()
    {
        if let gameState = representedObject as? GameState
        {
            for rm in observedRooms
            {
                if find(gameState.rooms, rm) == nil
                {
                    stopObserving(rm)
                }
            }
            for rm in gameState.rooms
            {
                if find(observedRooms, rm) == nil
                {
                    startObserving(rm)
                }
            }
        }
    }
    
    func startObserving(room: Room)
    {
        if let isObserved = find(observedRooms, room)
        {
            NSLog("Room already observed at ix: \(isObserved) - \(room)")
        }
        else
        {
            NSLog("%@ Start observing: %@", self, room)
            room.addObserver(self, forKeyPath: "roomKey",
                options: NSKeyValueObservingOptions.Old, context: &RoomObservingCtx)
            room.addObserver(self, forKeyPath: "roomName",
                options: NSKeyValueObservingOptions.Old, context: &RoomObservingCtx)
            observedRooms.append(room)
        }
    }
    
    func stopObserving(room: Room)
    {
        if let isObserved = find(observedRooms, room)
        {
            NSLog("%@ Stop observing: %@", self, room)
            room.removeObserver(self, forKeyPath: "roomKey", context: &RoomObservingCtx)
            room.removeObserver(self, forKeyPath: "roomName", context: &RoomObservingCtx)
            observedRooms.removeAtIndex(isObserved)
        }
        else
        {
            NSLog("Cannot stop observing room: \(room) - not listed as observed")
        }
    }
    
    func change(keyPath : String, ofObject object: NSObject, toValue: AnyObject?)
    {
        NSLog("Changed object: \(object) to be \(toValue)")
        object.setValue(toValue, forKeyPath: keyPath)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
    {
        NSLog("observeValueForKeyPath: \(keyPath) - object \(object)")
        let changeKindInt = change[NSKeyValueChangeKindKey] as UInt
        let changeKind = NSKeyValueChange(rawValue: changeKindInt)
        NSLog("kind: \(changeKind) - change: \(change)")
        var oldValue = change[NSKeyValueChangeOldKey] as? NSObject
        if (oldValue == NSNull())
        {
            NSLog("RoomList oldValue is nil")
            oldValue = nil
        }
        if (context == &RoomsListObservingCtx)
        {
            refreshRoomObserving()
        }
        else if (context == &RoomObservingCtx)
        {
            
            let undo = self.undoManager!
            undo.prepareWithInvocationTarget(self).change(keyPath, ofObject: object as NSObject, toValue: oldValue)
            undo.setActionName("Edit Room")
        }
        else
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

}