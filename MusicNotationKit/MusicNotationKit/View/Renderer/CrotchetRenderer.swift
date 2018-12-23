//
//  CrotchetRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 22/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class CrotchetRenderer {
    
    static func crotchetPaths(withPitch pitch: Pitch, staveCenterY: Double, xPos: Double, staveSpacing: Double) -> [Path] {
        
        var yPos = staveCenterY + (Double(pitch.staveOffset) * staveSpacing/2)
        
        // Subtract half a stave spacing so that the note centered on the pitch line
        yPos -= staveSpacing/2
        
        var notePath = SymbolPaths.filledNoteHead
        notePath.scale(staveSpacing)
        notePath.translate(x: xPos, y: yPos)
        
        
        // Stem path
        
        let stemWidth = 0.1
        let stemHeight = 3.0
        
        let stemX = 1.25
        let stemY = 0.6
        
        let stemRect = Rect(x: xPos + (stemX * staveSpacing),
                            y: yPos + (stemY * staveSpacing),
                            width: stemWidth * staveSpacing,
                            height: stemHeight * staveSpacing)
        
        var stemPath = Path()
        stemPath.addRect(stemRect)
        stemPath.drawStyle = .fill
        
        return [notePath, stemPath]
    }
}
