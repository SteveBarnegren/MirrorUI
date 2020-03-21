//
//  VerticalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class VerticalPositionerRenderOperation {
    
    func process(bars: [Bar]) {
        
        bars.forEachNote { note in
            self.position(note: note)
            note.leadingLayoutItems.forEach { self.position(adjacentLayoutItem: $0, forNote: note) }
            note.trailingLayoutItems.forEach { self.position(adjacentLayoutItem: $0, forNote: note) }
        }
    }
    
    private func position(note: Note) {
        note.yPosition = note.highestPitch.staveOffset
    }
    
    private func position(adjacentLayoutItem: AdjacentLayoutItem, forNote note: Note) {
        
        let notePitch = note.highestPitch
        
        switch adjacentLayoutItem {
        case let dot as DotSymbol:
            dot.position.y = dot.pitch.staveOffset
        case let sharp as SharpSymbol:
            sharp.position.y = notePitch.staveOffset
        case let flat as FlatSymbol:
            flat.position.y = notePitch.staveOffset
        case let natural as NaturalSymbol:
            natural.position.y = notePitch.staveOffset
        default:
            fatalError("Unknown item type: \(adjacentLayoutItem)")
        }
    }
    
}
