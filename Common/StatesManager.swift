//
//  StatesManager.swift
//  AdventureMachine
//
//  Created by Sarah Smith on 26/07/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class StatesManager
{
    let gameState : GameState

    let renderer = Renderer()
    var inventory : [ String ] = []
    
    private var _currentRoomLastKnown : Room?
    var currentRoom : Room? {
        get {
            if let rm = _currentRoomLastKnown
            {
                return rm
            }
            for rm in gameState.rooms
            {
                if rm.details.isCurrentRoom()
                {
                    return rm
                }
            }
            return gameState.rooms.first
        }
        set {
            _currentRoomLastKnown = newValue
            if let rm = newValue
            {
                
            }
        }
    }
    
    init(gameState initialGameState: GameState)
    {
        self.gameState = initialGameState
    }
    
// MARK: Main API
    
    // Called for supplying the top-level HTML text in the view window
    func currentHTML() -> String
    {
        renderer.setPageTitle(currentRoomName())
        renderer.addBodyParagraphs(currentDescription())
        renderer.addButtonLinks(currentOptions())
        return renderer.html()
    }
    
    func currentDescription() -> [ String ]
    {
        var descriptionItems = roomDescription()
        if let roomContent = roomContentsDescription()
        {
            descriptionItems.extend(roomContent)
        }
        if let exitsDesc = exitsDescription()
        {
            descriptionItems.extend(exitsDesc)
        }
        return descriptionItems
    }
    
    /** Returns all the possible options open for the player as an array of LinkDescriptions.  This is a concatenation of the movementOptions(), inventoryOptions() and actionOptions() */
    func currentOptions() -> [ LinkDescription ]
    {
        var result : Array<LinkDescription> = []
        result += movementOptions()
        result += inventoryOptions()
        result += actionOptions()
        return result
    }
    
    /** Returns the name of the current room.  If the current room is not set, returns "NOT IN ANY ROOM" */
    func currentRoomName() -> String
    {
        if let rm = currentRoom
        {
            return rm.roomName
        }
        return "NOT IN ANY ROOM"
    }
    
    /** Returns the Exit for a given act name eg "North", "Outside" if it exists in the current room. */
    func exit(forActName act: String) -> LinkDescription?
    {
        var result : LinkDescription?
        if let room = currentRoom
        {
            for exitLink in room.details.exits
            {
                if exitLink.linkAct == act
                {
                    result = exitLink
                    break
                }
            }
        }
        return result
    }
    
    func exit(forDestName dest: String) -> LinkDescription?
    {
        var result : LinkDescription?
        if let room = currentRoom
        {
            for exitLink in room.details.exits
            {
                if exitLink.linkDest == dest
                {
                    result = exitLink
                    break
                }
            }
        }
        return result
    }
    
    private var _roomForRoomKeyLookUp = [ String : Room ]()
    
    /** Find the room identified by the given key, or nil if no room has that key. */
    func room(forRoomKey key: String) -> Room?
    {
        var result : Room?
        if let rm = _roomForRoomKeyLookUp[key]
        {
            result = rm
        }
        else
        {
            for rm in gameState.rooms
            {
                if rm.roomKey == key
                {
                    _roomForRoomKeyLookUp[key] = rm
                    result = rm
                    break
                }
            }
        }
        return result
    }
    
    private var _objectForObjectKeyLookUp = [ String : GameObject ]()
    
    /** Find the object identified by the given key, or nil if the object cannot be found. */
    func object(forObjectKey key: String) -> GameObject?
    {
        var result : GameObject?
        if let obj = _objectForObjectKeyLookUp[key]
        {
            result = obj
        }
        else
        {
            for rm in gameState.rooms
            {
                for obj in rm.details.objects
                {
                    if obj.objectName == key
                    {
                        _objectForObjectKeyLookUp[key] = obj
                        result = obj
                        break
                    }
                }
            }
        }
        return result
    }
    
// MARK: State modifiying functions
    
    // Called to execute an action from a button
    func executeAction( action: String ) -> ( actName: String, actResult: String )
    {
        let allExitActs = currentRoom!.details.exits
        if let exitAct = exit(forDestName: action)
        {
            if let matchingRoom = room(forRoomKey: exitAct.linkDest)
            {
                currentRoom = matchingRoom
                return ( exitAct.linkAct, "You move \(exitAct.linkAct).  You are now in \(matchingRoom.roomName)" )
            }
        }
        return ( "What?", "Did not understand action: \( action )" )
    }
    
    func move(gameObj: GameObject, toRoom room: Room)
    {
        remove(gameObj, fromRoom: room)
        add(gameObj, toRoom: room)
    }
    
    func remove(object: GameObject, fromRoom room: Room)
    {
        if let ix = find(room.details.objects, object)
        {
            room.details.objects.removeAtIndex(ix)
        }
    }
    
    func add(gameObj: GameObject, toRoom room: Room)
    {
        room.details.objects.append(gameObj)
    }
    
// MARK: Actions reporting functions
    
    
    func movementOptions() -> [ LinkDescription ]
    {
        if let rm = currentRoom
        {
            return rm.details.exits
        }
        return []
    }
    
    func inventoryOptions() -> [ LinkDescription ]
    {
        return []
    }
    
    func actionOptions() -> [ LinkDescription ]
    {
        return []
    }
    
// MARK Description functions
    
    func roomDescription() -> [ String ]
    {
        if let rm = currentRoom
        {
            return [ rm.details.roomDescription ]
        }
        return [ "An empty room." ]
    }

    func playerDescription() -> String
    {
        return "Full-health."
    }
    
    func roomContentsDescription() -> [ String ]?
    {
        var result : [ String ]?
//        var objectNames = currentRoom!.objects.keys.array
//        if let ix = find(objectNames, "Player")
//        {
//            objectNames.removeAtIndex(ix)
//        }
//        if objectNames.isEmpty
//        {
//            return nil
//        }
//        if objectNames.count == 1
//        {
//            return "There is \(objectNames[0]) here."
//        }
//        let lastName = objectNames.removeLast()
//        let otherNames = join(", ", objectNames)
//        return "Also here are \(otherNames) and \(lastName)"
        return result
    }
    
    func exitsDescription() -> [ String ]?
    {
        var result : [ String ]?
        return result
    }
    
}