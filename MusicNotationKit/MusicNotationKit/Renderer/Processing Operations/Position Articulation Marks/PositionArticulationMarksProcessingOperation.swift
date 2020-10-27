//
//  PositionArticulationMarksProcessingOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 26/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class PositionArticulationMarksProcessingOperation: CompositionProcessingOperation {
    
    func process(composition: Composition) {
        
        for bar in composition.bars {
            for sequence in bar.sequences {
                for note in sequence.notes {
                    self.process(note: note)
                }
            }
        }
    }
    
    private func process(note: Note) {
        
        let articulations = note.articulationMarks
        if articulations.isEmpty {
            return
        }
        
        let pitch: Pitch
        let spaceOffset: Int
        let lineRounding: StaveSpace.LineRounding
        switch note.symbolDescription.stemDirection {
        case .up:
            pitch = note.lowestPitch
            spaceOffset = -1
            lineRounding = .spaceBelow
        case .down:
            pitch = note.highestPitch
            spaceOffset = 1
            lineRounding = .spaceAbove
        }
        
        var staveSpace = StaveSpace(stavePosition: pitch.stavePosition, lineRounding: lineRounding)
        staveSpace = staveSpace.adding(spaces: spaceOffset)
        let stavePosition = staveSpace.stavePosition
        
        for articulation in articulations {
            articulation.stavePosition = stavePosition
            articulation.note = note
        }
        
    }
}
