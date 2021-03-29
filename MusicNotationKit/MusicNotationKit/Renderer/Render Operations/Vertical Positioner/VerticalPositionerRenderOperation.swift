//
//  VerticalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class VerticalPositionerRenderOperation {
    
    func process(bars: [BarSlice]) {
        bars.forEach(process)
    }
    
    func process(barSlice: BarSlice) {
        barSlice.bars.forEach(process)
    }
    
    private func process(bar: Bar) {
        bar.forEachNote { note in
            self.positionNoteHeads(forNote: note)
            note.leadingChildItems.forEach { 
                self.position(adjacentLayoutItem: $0, forNote: note, clef: bar.clef) 
            }
            note.trailingChildItems.forEach { 
                self.position(adjacentLayoutItem: $0, forNote: note, clef: bar.clef) 
            }
        }
    }
    
    private func positionNoteHeads(forNote note: Note) {
        for noteHead in note.noteHeads {
            noteHead.yPosition = noteHead.stavePosition.yPosition
        }
    }
    
    private func position(adjacentLayoutItem: AdjacentLayoutItem, forNote note: Note, clef: Clef) {
                
        switch adjacentLayoutItem {
        case let dot as DotSymbol:
            dot.position.y = dot.stavePosition.yPosition
        case let accidental as AccidentalSymbol:
            accidental.position.y = accidental.stavePosition.yPosition
        default:
            fatalError("Unknown item type: \(adjacentLayoutItem)")
        }
    }
    
}
