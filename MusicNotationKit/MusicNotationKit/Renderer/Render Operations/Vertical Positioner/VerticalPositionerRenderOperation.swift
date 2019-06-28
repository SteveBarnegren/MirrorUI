//
//  VerticalPositioner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class VerticalPositionerRenderOperation: RenderOperation {
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.enumerateNotes { note in
            self.position(note: note)
            note.leadingLayoutItems.forEach { self.position(adjacentLayoutItem: $0, forNote: note) }
            note.trailingLayoutItems.forEach { self.position(adjacentLayoutItem: $0, forNote: note) }
        }
    }
    
    private func position(note: Note) {
        note.position.y = note.pitch.staveOffset - 0.5
    }
    
    private func position(adjacentLayoutItem: HorizontalLayoutItem, forNote note: Note) {
        
        switch adjacentLayoutItem {
        case let dot as DotSymbol:
            dot.position.y = dot.pitch.staveOffset
        case let sharp as SharpSymbol:
            sharp.position.y = note.pitch.staveOffset
        default:
            fatalError("Unknown item type: \(adjacentLayoutItem)")
        }
    }
    
}
