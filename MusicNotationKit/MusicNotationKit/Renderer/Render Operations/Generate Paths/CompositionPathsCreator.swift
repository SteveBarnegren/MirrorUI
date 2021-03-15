//
//  CompositionPathsCreator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct RenderableVoice {
    var bars: [Bar]
    var leadingTies: [Tie]
}

class CompositionPathsCreator {
    
    private let noteRenderer: NoteRenderer
    private let tieRenderer: TieRenderer
    private let sharpRenderer: SharpRenderer
    private let flatRenderer: FlatRenderer
    private let naturalRenderer: NaturalRenderer
    private let dotRenderer: DotRenderer
    private let restRenderer: RestRenderer
    
    init(glyphs: GlyphStore) {
        self.noteRenderer = NoteRenderer(glyphs: glyphs)
        self.tieRenderer = TieRenderer(glyphs: glyphs)
        self.sharpRenderer = SharpRenderer(glyphs: glyphs)
        self.flatRenderer = FlatRenderer(glyphs: glyphs)
        self.naturalRenderer = NaturalRenderer(glyphs: glyphs)
        self.dotRenderer = DotRenderer(glyphs: glyphs)
        self.restRenderer = RestRenderer(glyphs: glyphs)
    }
    
    func paths(forVoices voices: [RenderableVoice], canvasWidth: Double, staveSpacing: Double) -> [Path] {
        
        var yOffset = 0.0
        var allPaths = [Path]()
        for (index, voice) in voices.enumerated() {
            
            var paths = self.paths(fromBars: voice.bars,
                                   canvasWidth: canvasWidth, 
                                   staveSpacing: staveSpacing,
                                   leadingTies: voice.leadingTies)
            if index != 0 {
                yOffset += paths.map { $0.maxY }.max() ?? 0
            }
            
            if yOffset != 0 {
                paths = paths.map { $0.translated(x: 0, y: yOffset)  }
            }
            allPaths += paths
            yOffset += abs( paths.map { $0.minY }.min() ?? 0 )
        }
        
        return allPaths
    }
    
    func paths(fromBars bars: [Bar], canvasWidth: Double, staveSpacing: Double, leadingTies: [Tie]) -> [Path] {
        
        let barRange = (bars.first!.barNumber)...(bars.last!.barNumber)
        print("Creating paths for bar range \(barRange)")
        
        var paths = bars.map {
            makePaths(forBar: $0, inRange: barRange, canvasWidth: canvasWidth, leadingTies: leadingTies)
        }.joined().toArray()
        
        // Make the path for the last barline
        if let lastBarline = bars.last?.trailingBarline {
            paths += BarlineRenderer().paths(forBarline: lastBarline)
        }
        
        paths += StaveRenderer.stavePaths(withWidth: canvasWidth)
        paths = paths.map { $0.scaled(staveSpacing) }
        return paths
    }
    
    private func makePaths(forBar bar: Bar, inRange barRange: ClosedRange<Int>, canvasWidth: Double, leadingTies: [Tie]) -> [Path] {
        
        let barlinePath = BarlineRenderer().paths(forBarline: bar.leadingBarline)
        
        let notePaths =  bar.sequences.map {
            makePaths(forNoteSequence: $0, inRange: barRange, canvasWidth: canvasWidth, leadingTies: leadingTies)
        }.joined().toArray()
        
        return barlinePath + notePaths
    }
    
    private func makePaths(forNoteSequence noteSequence: NoteSequence,
                           inRange barRange: ClosedRange<Int>,
                           canvasWidth: Double,
                           leadingTies: [Tie]) -> [Path] {
        
        let notePaths = noteRenderer.paths(forNotes: noteSequence.notes)
        let noteSymbolPaths = noteSequence.notes.map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let noteHeadAdjacentItems = noteSequence.notes.map { $0.noteHeads }.joined().map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let restPaths = restRenderer.paths(forRests: noteSequence.rests)
        
        let articulationMarkPaths = noteSequence.notes.map { note in
            note.articulationMarks.map { makePaths(forArticulationMark: $0, xPos: note.xPosition) }.joined()
        }.joined().toArray()
        
        let tupletMarkPaths = TupletMarksRenderer().paths(forNoteSequence: noteSequence)
        
        // Draw ties
        var tiePaths = [Path]()
        for note in noteSequence.notes {
            for noteHeadDescription in note.noteHeads {
                if let tie = noteHeadDescription.tie?.chosenVariation {
                    tiePaths += tieRenderer.paths(forTie: tie,
                                                  inBarRange: barRange,
                                                  canvasWidth: canvasWidth)
                }
            }
        }
        
        // Draw leading ties
        var leadingTiePaths = [Path]()
        for tie in leadingTies {
            leadingTiePaths += tieRenderer.paths(forTie: tie,
                                                 inBarRange: barRange,
                                                 canvasWidth: canvasWidth)
        }
        
        var allPaths = [Path]()
        allPaths += notePaths
        allPaths += noteSymbolPaths
        allPaths += noteHeadAdjacentItems
        allPaths += restPaths
        allPaths += tiePaths
        allPaths += leadingTiePaths
        allPaths += articulationMarkPaths
        allPaths += tupletMarkPaths
        return allPaths
    }
    
    // Render Symbols
    
    private func makePaths(forSymbol symbol: AdjacentLayoutItem) -> [Path] {
        
        switch symbol {
        case let dot as DotSymbol:
            return dotRenderer.paths(forDot: dot)
        case let accidental as AccidentalSymbol:
           return makePaths(forAccidentalSymbol: accidental)
        default:
            fatalError("Unknown symbol type: \(symbol)")
        }
    }
    
    private func makePaths(forAccidentalSymbol accidentalSymbol: AccidentalSymbol) -> [Path] {
        
        let x = accidentalSymbol.xPosition
        let y = accidentalSymbol.yPosition
        
        switch accidentalSymbol.type {
        case .sharp:
            return sharpRenderer.paths(forSharpAtX: x, y: y)
        case .flat:
            return flatRenderer.paths(forFlatAtX: x, y: y)
        case .natural:
            return naturalRenderer.paths(forNaturalAtX: x, y: y)
        }
    }
    
    // MARK: - Render Articulation
    
    private func makePaths(forArticulationMark articulation: ArticulationMark, xPos: Double) -> [Path] {
        
        if let accent = articulation as? Accent {
            return AccentRenderer().paths(forAccent: accent, xPos: xPos)
        } else {
            fatalError("Unknown articulation type: \(articulation)")
        }
    }
}
