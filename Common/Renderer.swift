//
//  Renderer.swift
//  SwiftQuest
//
//  Created by Sarah Smith on 23/12/2014.
//  Copyright (c) 2014 Sarah Smith. All rights reserved.
//

import Foundation

class Renderer
{
    var templates = [ String : GRMustacheTemplate ]()
    
    let htmlPage : GRMustacheTemplate
    
    private var _pageTitle : String?
    private var _bodyTextParagraphs : [ String ]?
    private var _buttonAssembly : [ LinkDescription ]?
    private var _codaParagrahps : [ String ]?
    private var _javascriptEntries : [ String ]?
    private var _popoverFields : [ String : String ]?
    
    init() {
        let bundle = NSBundle(forClass: Renderer.self)
        let path = bundle.pathForResource("templates/template", ofType: "html")!
        var err : NSError?
        htmlPage = GRMustacheTemplate(fromContentsOfFile: path, error: &err)
    }
    
// MARK: HTML generation
    
    /** Return a string of HTML for the renderers current state as set up by earlier calls to setTitle and other page-model accessors.  Will reset the page-model to empty. */
    func html() -> String
    {
        var templateFields = [ "header" : "Untitled", "content" : "Nothing special." ]
        if let title = _pageTitle
        {
            templateFields["header"] = title
            _pageTitle = nil
        }
        if let bodyText = _bodyTextParagraphs
        {
            templateFields["content"] = htmlParagraphs(bodyText)
            _bodyTextParagraphs = nil
        }
        if let buttons = _buttonAssembly
        {
            let buttonLinks = buttons.map { lnk in self.createLinkButton(lnk) }
            let btns = "".join(buttonLinks)
            templateFields["buttons"] = btns
            _buttonAssembly = nil
        }
        if let popover = _popoverFields
        {
            let popoverHTML = render(templateName: "popover", withObject: popover)
            addCodaParagraph(popoverHTML)
            addJavascript("$('#myModal').modal('show');")
            _popoverFields = nil
        }
        if let coda = _codaParagrahps
        {
            templateFields["coda"] = htmlParagraphs(coda)
            _codaParagrahps = nil
        }
        if let javascriptTexts = _javascriptEntries
        {
            templateFields["javascriptText"] = "\n".join(javascriptTexts)
        }
        var errorReport : NSError?
        let result = htmlPage.renderObject(templateFields, error: &errorReport)
        if let err = errorReport
        {
            NSLog("%@", templateFields)
            NSLog("Rendering failed: \(err.localizedDescription)")
            return "<html><body><h1>Error</h1><p>\(err.localizedDescription)</p></body></html>"
        }
        return result
    }
    
    func htmlParagraphs( list: [String]? ) -> String?
    {
        if let listStrings = list
        {
            if listStrings.count == 0
            {
                return nil
            }
            else if listStrings.count == 1
            {
                return "<p>\(listStrings[0])</p>"
            }
            else
            {
                return "<p>" + join("</p><p>", listStrings) + "</p>"
            }
        }
        return nil
    }
    
// MARK: Page model accessors
    
    func setPageTitle(pageTitle: String)
    {
        _pageTitle = pageTitle
    }
    
    func addBodyParagraphs(paragraphs: [ String ])
    {
        if _bodyTextParagraphs == nil
        {
            _bodyTextParagraphs = paragraphs
        }
        else
        {
            _bodyTextParagraphs!.extend(paragraphs)
        }
    }
    
    func addButtonLinks(linkArray: [ LinkDescription ])
    {
        if _buttonAssembly == nil
        {
            _buttonAssembly = linkArray
        }
        else
        {
            _buttonAssembly!.extend(linkArray)
        }
    }
    
    func addCodaParagraph(coda: String)
    {
        if _codaParagrahps == nil
        {
            _codaParagrahps = [ coda ]
        }
        else
        {
            _codaParagrahps!.append(coda)
        }
    }
    
    /** Sets up a snippet of javascript to be inserted in the page.  It is placed at the end of the page, after jQuery is loaded. */
    func addJavascript(javascript: String)
    {
        if _javascriptEntries == nil
        {
            _javascriptEntries = [ javascript ]
        }
        else
        {
            _javascriptEntries!.append(javascript)
        }
    }
    
    func setPopover(bodyText text: String, titleText title: String, buttonLabel: String = "OK" )
    {
        _popoverFields = [ "popoverTitle" : title, "popoverBody" : text, "buttonLabel" : buttonLabel ]
    }
    
    
// MARK:  Low-level template renderers
    
    func render( #templateName : String, withObject: AnyObject ) -> String
    {
        var template : GRMustacheTemplate!
        if let templateActual = templates[ templateName ]
        {
            template = templateActual
        }
        else
        {
            let bundle = NSBundle(forClass: Renderer.self)
            let path = bundle.pathForResource("templates/\(templateName)", ofType: "html")!
            var err : NSError?
            if let templateLoad = GRMustacheTemplate(fromContentsOfFile: path, error: &err)
            {
                template = templateLoad
                templates.updateValue(templateLoad, forKey: templateName)
            }
            else
            {
                NSLog("Could not load template %@", path)
                if let errActual = err
                {
                    NSLog("    %@", errActual.localizedDescription)
                }
            }
        }
        if let result = template.renderObject(withObject, error: nil)
        {
            return result
        }
        return ""
    }
    
    func createImageThumbnail( link: String ) -> String
    {
        return render(templateName: "imageElement", withObject: link)
    }
    
    func createLinkButton( link: LinkDescription ) -> String
    {
        return render(templateName: "linkButton", withObject: link)
    }
    
    func createNavButton( link: LinkDescription ) -> String
    {
        return render(templateName: "navButton", withObject: link)
    }
    
    func urlCleanName( name: String ) -> String
    {
        if name == "" { return "" }
        
        let badChars = NSRegularExpression(pattern: "[^\\p{L} #-]+", options: nil, error: nil)!
        let allName = NSRange(location: 0, length: countElements(name))
        var result = badChars.stringByReplacingMatchesInString(name, options: nil, range: allName, withTemplate: "")
        if result == "" { return "" }
        
        let allName2 = NSRange(location: 0, length: countElements(result))
        let spaces = NSRegularExpression(pattern: "\\s+", options: nil, error: nil)!
        result = spaces.stringByReplacingMatchesInString(result, options: nil, range: allName2, withTemplate: "-")
        result = result.lowercaseString
        return result
    }

}