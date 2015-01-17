//
//  GradientButtonCell.swift
//  SwiftAdventure
//
//  Created by Sarah Smith on 3/01/2015.
//  Copyright (c) 2015 Sarah Smith. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable  class GradientButtonCell : NSButtonCell
{
    @IBInspectable var startColor : NSColor = NSColor.lightGrayColor() {
        didSet {
            //
        }
    }
    @IBInspectable var endColor : NSColor = NSColor.darkGrayColor() {
        didSet {
            //
        }
    }
    
    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView)
    {
        if (highlighted)
        {
            let startLow = startColor.shadowWithLevel(0.2)
            let endLow = endColor.shadowWithLevel(0.2)
            let gradient = NSGradient(startingColor: startLow!, endingColor: endLow!)
            gradient.drawInRect(frame, angle: 90.0)
        }
        else
        {
            let gradient = NSGradient(startingColor: startColor, endingColor: endColor)
            gradient.drawInRect(frame, angle: 90.0)
        }
        NSBezierPath.strokeRect(frame)
    }
}