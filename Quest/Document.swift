//
//  Document.swift
//  Quest
//
//  Created by Sarah Smith on 11/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Cocoa

class Document: NSDocument
{    
    @IBOutlet var rootViewController : RootViewController!
    @IBOutlet var loadingLabel : NSTextField!
    
    var gameState = GameState()
    
    override init()
    {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController)
    {
        super.windowControllerDidLoadNib(aController)
        let gsvc = rootViewController.gameStateViewController
        gsvc.representedObject = gameState
        loadingLabel.hidden = true
    }

    override class func autosavesInPlace() -> Bool
    {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        return NSKeyedArchiver.archivedDataWithRootObject(gameState)
        
        //        outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        //        return nil
    }

    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//        outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//        return false
        NSLog("readFromData: \(typeName)")
        if let gameStateObject: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        {
            gameState = gameStateObject as GameState
        }
        else
        {
            let errorMessage = "Failed to load"
            NSLog("#### \(errorMessage)")
            outError.memory = NSError(domain: NSOSStatusErrorDomain, code: readErr,
                userInfo: [ NSLocalizedDescriptionKey : errorMessage])
            return false
        }
        NSLog("Loaded: \(gameState)")
        return true
    }
    
    override func prepareSavePanel(savePanel: NSSavePanel) -> Bool
    {
        if (gameState.gameName != "Game Title")
        {
            savePanel.nameFieldStringValue = gameState.gameName
        }
        return true
    }
}

