//
//  HorizontalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalPositioner {
    
    func process(composition: Composition, layoutWidth: Double) {
        let barWidth = layoutWidth / Double(composition.numberOfBars)
        for (index, bar) in composition.bars.enumerated() {
            process(bar: bar, width: barWidth, offset: barWidth * Double(index))
        }
    }
    
    private func process(bar: Bar, width: Double, offset: Double) {
        for noteSequence in bar.sequences {
            process(noteSequence: noteSequence, width: width, offset: offset)
        }
    }
    
    private func process(noteSequence: NoteSequence, width: Double, offset: Double) {
        
        let positions = HorizontalConstraintSolver().solve(noteSequence.notes, layoutWidth: width)
        for (note, position) in zip(noteSequence.notes, positions) {
            note.position.x = position + offset
        }
    }
}
