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
    
    init() {
        let bundle = NSBundle(forClass: Renderer.self)
        let path = bundle.pathForResource("templates/template", ofType: "html")!
        var err : NSError?
        htmlPage = GRMustacheTemplate(fromContentsOfFile: path, error: &err)
    }
    
    func htmlTemplate( htmlTitle: String, bodyText: String, buttons: [ LinkDescription ] = []) -> String
    {
        let buttonLinks = buttons.map { lnk in self.createLinkButton(lnk) }
        let navLinks = buttons.map { lnk in self.createNavButton(lnk) }
        let btns = "".join(buttonLinks)
        let result = htmlPage.renderObject( [ "title" : htmlTitle, "header" : htmlTitle,
            "content" : bodyText, "buttons" : btns ], error: nil )
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