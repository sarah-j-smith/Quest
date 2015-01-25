//
//  QuestViewController.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 22/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class QuestView : NSViewController
{
    @IBOutlet var webView : WebView!
    
    var stateManager : StatesManager!
    
    var model : GameState {
        set {
            stateManager = StatesManager(gameState: newValue)
        }
        get {
            return stateManager.gameState
        }
    }
    
    func loadHtml(htmlString: String)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let webPath: String = defaults.valueForKey("webpath") as? String
        {
            var err : NSError?
            let ok = htmlString.writeToFile(webPath, atomically: false, encoding: NSUTF8StringEncoding, error: &err)
            if (ok)
            {
                NSLog("Wrote HTML: \(webPath)")
            }
            else
            {
                NSLog("Could not write to file \(webPath) : \(err?.localizedDescription)")
            }
        }
        else
        {
            NSLog("No log directory specified for saving HTML file")
        }
        let bundle = NSBundle.mainBundle()
        let baseURL = bundle.resourceURL
        
        webView.mainFrame.loadHTMLString(htmlString, baseURL: baseURL)
    }
    
    func refreshView()
    {
        let html = stateManager.currentHTML()
        loadHtml(html)
    }
    
    func showAlert(alertString: String, title: String)
    {
//        let alert = NSAlert()
//        alert.messageText = title
//        alert.informativeText = alertString
//        alert.alertStyle = NSAlertStyle.InformationalAlertStyle
//        alert.addButtonWithTitle("OK")
//        
//        if let w = webView.window
//        {
//            alert.beginSheetModalForWindow(w, completionHandler: { (response: NSModalResponse) -> Void in
//                self.refreshView()
//            })
//        }
        stateManager.renderer.setPopover(bodyText: alertString, titleText: title)
        refreshView()
    }
    
    override func webView(sender: WebView!, didFailLoadWithError error: NSError!, forFrame frame: WebFrame!)
    {
        print("didFailLoadWithError")
        println(error)
    }
    
    override func webView(sender: WebView!, didFailProvisionalLoadWithError error: NSError!, forFrame frame: WebFrame!)
    {
        print("didFailProvisionalLoadWithError")
        println(error)
    }
    
    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
    {
        print("decidePolicyForNavigationAction: ")
        println(request.URL)
        if let frag = request.URL.fragment
        {
            let ( actName, newText ) = stateManager.executeAction( frag )
            showAlert(newText, title: actName )
            NSLog("Got fragment: \(frag)")
        }
        listener.use()
    }

}
