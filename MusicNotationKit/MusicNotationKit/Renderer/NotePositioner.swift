//
//  NotePositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NotePositioner {
    
    private let canvasSize: Size
    
    init(canvasSize: Size) {
        self.canvasSize = canvasSize
    }
    
    func process(composition: Composition) {
        
        let widthPerBar = canvasSize.width / Double(composition.bars.count)
        
        for bar in composition.bars {
            layout(bar: bar, width: widthPerBar)
        }
    }
    
    private func layout(bar: Bar, width: Double) {
        for noteSequence in bar.sequences {
            applyHorizontalPositions(toNoteSequence: noteSequence, width: width)
        }
    }
    
    private func applyHorizontalPositions(toNoteSequence noteSequence: NoteSequence, width: Double) {
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
