//
//  CompositionPathsCreator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private let staveSeparation = 0.8

struct RenderableVoice {
    var bars: [Bar]
    var leadingTies: [Tie]
}

class CompositionPathsCreator {
    
    private let glyphRenderer: GlyphRenderer
    private let noteRenderer: NoteRenderer
    private let tieRenderer: TieRenderer
    private let tupletMarksRenderer: TupletMarksRenderer
    
    init(glyphs: GlyphStore) {
        self.glyphRenderer = GlyphRenderer(glyphStore: glyphs)
        self.noteRenderer = NoteRenderer(glyphs: glyphs)
        self.tieRenderer = TieRenderer(glyphs: glyphs)
        self.tupletMarksRenderer = TupletMarksRenderer(glyphs: glyphs)
    }
    
    func paths(forVoices voices: [RenderableVoice], canvasWidth: Double, staveSpacing: Double) -> [Path] {
        
        var yOffset = 0.0
        var allPaths = [Path]()
        for (index, voice) in voices.enumerated() {
            
            var paths = self.paths(fromBars: voice.bars,
                                   canvasWidth: canvasWidth, 
                                   leadingTies: voice.leadingTies)
            
            if index != 0 {
                yOffset += abs(paths.minY)
            }
            
            if yOffset != 0 {
                paths = paths.map { $0.translated(x: 0, y: yOffset)  }
            }
            allPaths += paths
            yOffset += abs(paths.maxY)
            yOffset += staveSeparation
        }
        
        return allPaths.map { $0.scaled(staveSpacing) }
    }
    
    func paths(fromBars bars: [Bar], canvasWidth: Double, leadingTies: [Tie]) -> [Path] {
        
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
        return paths
    }
    
    private func makePaths(forBar bar: Bar, inRange barRange: ClosedRange<Int>, canvasWidth: Double, leadingTies: [Tie]) -> [Path] {
        
        let barlinePath = BarlineRenderer().paths(forBarline: bar.leadingBarline)
        let clefPath = bar.isFirstBarInLine ? glyphRenderer.paths(forRenderable: bar.clefSymbol) : []
        
        let notePaths =  bar.sequences.map {
            makePaths(forNoteSequence: $0, inRange: barRange, canvasWidth: canvasWidth, leadingTies: leadingTies)
        }.joined().toArray()
        
        return barlinePath + clefPath + notePaths
    }
    
    private func makePaths(forNoteSequence noteSequence: NoteSequence,
                           inRange barRange: ClosedRange<Int>,
                           canvasWidth: Double,
                           leadingTies: [Tie]) -> [Path] {
        
        let notePaths = noteRenderer.paths(forNotes: noteSequence.notes)
        let noteSymbolPaths = noteSequence.notes.map { $0.trailingChildItems + $0.leadingChildItems }.joined().map(makePaths).joined().toArray()
        let noteHeadAdjacentItems = noteSequence.notes.map { $0.noteHeads }.joined().map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let restPaths = noteSequence.rests.map(glyphRenderer.paths).joined()
        
        let articulationMarkPaths = noteSequence.notes.map { note in
            note.articulationMarks.map { makePaths(forArticulationMark: $0, xPos: note.xPosition) }.joined()
        }.joined().toArray()
        
        let tupletMarkPaths = tupletMarksRenderer.paths(forNoteSequence: noteSequence)
        
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
        
        if let singleGlyphRenderable = symbol as? SingleGlyphRenderable {
            return glyphRenderer.paths(forRenderable: singleGlyphRenderable)
        } else {
            fatalError("Unknown symbol type: \(symbol)")
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
