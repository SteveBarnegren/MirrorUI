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
            note.trailingLayoutItems.forEach(self.position(trailingLayoutItem:))
        }
    }
    
    private func position(note: Note) {
        note.position.y = note.pitch.staveOffset - 0.5
    }
    
    private func position(trailingLayoutItem: HorizontalLayoutItem) {
        
        switch trailingLayoutItem {
        case let dot as DotSymbol:
            dot.position.y = dot.pitch.staveOffset
        default:
            fatalError("Unknown trailing item type: \(trailingLayoutItem)")
        }
    }
    
}
