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
    
    let rndr = Renderer()
    var model = GameState()
    var currentRoom : Room?
    
    func refreshView()
    {
        let room = currentRoom!
        let okLink = LinkDescription(act: "OK", dest: "#OK", type: "ok")
        let paras = rndr.htmlParagraphs([room.details.roomDescription])
        let html = rndr.htmlTemplate(room.roomName, bodyText: paras!, buttons: [ okLink ])
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let webPath: String = defaults.valueForKey("webpath") as? String
        {
            var err : NSError?
            let ok = html.writeToFile(webPath, atomically: false, encoding: NSUTF8StringEncoding, error: &err)
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
        
        webView.mainFrame.loadHTMLString(html, baseURL: baseURL)
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
//            let ( actName, newText ) = stateMgr.executeAction( frag )
//            showAlert(newText, title: actName )
            NSLog("Got fragment: \(frag)")
        }
        listener.use()
    }

}
