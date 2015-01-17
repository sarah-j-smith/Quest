//
//  GradientView.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 3/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable class GradientView : NSView
{
    @IBInspectable var startColor : NSColor = NSColor.lightGrayColor() {
        didSet {
            needsDisplay = true
        }
    }
    @IBInspectable var endColor : NSColor = NSColor.darkGrayColor() {
        didSet {
            needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let gradient = NSGradient(startingColor: startColor, endingColor: endColor)
        gradient.drawInRect(bounds, angle: 270.0)
    }
}