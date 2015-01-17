//
//  AppDelegate.swift
//  Quest
//
//  Created by Sarah Smith on 11/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{

    var hasStarted = false

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool
    {
        NSLog("applicationShouldOpenUntitledFile")
        if !hasStarted
        {
            hasStarted = true
            NSLog("App has not started - trying recent docs instead of blank doc")
            let dc = NSDocumentController.sharedDocumentController() as NSDocumentController
            let recentURLs = dc.recentDocumentURLs
            NSLog("    applicationShouldOpenUntitledFile\n\(recentURLs)")
            if recentURLs.count > 0
            {
                NSLog("Recent URLs: \(recentURLs)")
                dc.openDocumentWithContentsOfURL(recentURLs[0] as NSURL, display: true, completionHandler: {
                    (doc:NSDocument!, wasAlreadyOpen: Bool, err: NSError!) -> Void in
                    if doc == nil
                    {
                        NSLog("   failed to load: \(recentURLs[0])")
                        dc.openUntitledDocumentAndDisplay(true, error: nil)
                    }
                    else
                    {
                        NSLog("    Opened document: \(doc.displayName)")
                    }
                })
                // If there are any recent URLs assume that we can open one, and therefore don't open an
                // untitled file.  If it in fact fails (because the file has gone away) recover by opening
                // an untitled file in the completion handler.  Note that the call to open an untitled file
                // will loop back and call this method again, but that's OK: the next time its called the
                // recentURLs will have been updated so it won't repeat forever
                return false
            }
        }
        // Either the app has started (and this request to open an untitled file came from File > New)
        // or there were no recent documents, so yeah - go ahead an open an untitled file
        
        NSLog("Application should open untitled file!")
        return true
    }

}

