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
        
        composition.forEachBar(process)
        composition.forEachNote(applyAdjacentItemWidths)
    }
    
    private func process(bar: Bar) {
        
        bar.forEachNote {
            
            // Make basic symbol description
            let description = noteSymbolDescriber.symbolDescription(forNote: $0)
            $0.hasStem = description.hasStem
            $0.numberOfTails = description.numberOfTails
            
            // Make note head descriptions
            $0.noteHeads = noteHeadDescriber.noteHeadDescriptions(forNote: $0, clef: bar.clef)
        }
        
        bar.forEachRest { $0.symbolDescription = restSymbolDescriber.symbolDescription(forRest: $0) }
    }
    
    // MARK: - Apply adjacent item widths from font
    
    private func applyAdjacentItemWidths(note: Note) {
        
        for item in (note.leadingChildItems + note.trailingChildItems) {
            applyAdjacentItemWidth(item: item)
        }
    }
    
    private func applyAdjacentItemWidth(item: AdjacentLayoutItem) {
        
        if let accidental = item as? AccidentalSymbol {
            applyAccidentalWidth(accidental: accidental)
        } else if let dot = item as? DotSymbol {
            dot.horizontalLayoutWidth = .centered(width: glyphs.glyph(forType: .augmentationDot).width)
        }
    }
    
    private func applyAccidentalWidth(accidental: AccidentalSymbol) {
        
        let glyph: Glyph
        
        switch accidental.type {
        case .sharp:
            glyph = glyphs.glyph(forType: .accidentalSharp)
        case .flat:
            glyph = glyphs.glyph(forType: .accidentalFlat)
        case .natural:
            glyph = glyphs.glyph(forType: .accidentalNatural)
        }
        
        accidental.horizontalLayoutWidth = .centered(width: glyph.width)
    }
}
