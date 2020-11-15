//
//  GenerationSymbolDescriptionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class GenerateSymbolDescriptionsProcessingOperation: CompositionProcessingOperation {
    
    private let glyphs: GlyphStore
    private let noteSymbolDescriber = NoteSymbolDescriber()
    private let noteHeadDescriber = NoteHeadDescriber()
    private let restSymbolDescriber = RestSymbolDescriber()
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func process(composition: Composition) {
        
        composition.enumerateNotes {
            $0.symbolDescription = noteSymbolDescriber.symbolDescription(forNote: $0)
            $0.noteHeadDescriptions = noteHeadDescriber.noteHeadDescriptions(forNote: $0)
        }
        composition.enumerateRests { $0.symbolDescription = restSymbolDescriber.symbolDescription(forRest: $0) }
        
        composition.enumerateNotes(applyAdjacentItemWidths)
    }
    
    // MARK: - Apply adjacent item widths from font
    
    private func applyAdjacentItemWidths(note: Note) {
        
        for item in (note.leadingLayoutItems + note.trailingLayoutItems) {
            applyAdjacentItemWidth(item: item)
        }
    }
    
    private func applyAdjacentItemWidth(item: AdjacentLayoutItem) {
        
        if let accidental = item as? AccidentalSymbol {
            applyAccidentalWidth(accidental: accidental)
        } else if let dot = item as? DotSymbol {
            dot.horizontalLayoutWidth = .centered(width: glyphs.augmentationDot.width)
        }
    }
    
    private func applyAccidentalWidth(accidental: AccidentalSymbol) {
        
        let glyph: Glyph
        
        switch accidental.type {
        case .sharp:
            glyph = glyphs.accidentalSharp
        case .flat:
            glyph = glyphs.accidentalFlat
        case .natural:
            glyph = glyphs.accidentalNatural
        }
        
        accidental.horizontalLayoutWidth = .centered(width: glyph.width)
    }
}
