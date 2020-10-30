//
//  CompositionPathsCreator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CompositionPathsCreator {
    
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
        
        let notePaths = NoteRenderer().paths(forNotes: noteSequence.notes)
        let noteSymbolPaths = noteSequence.notes.map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let noteHeadAdjacentItems = noteSequence.notes.map { $0.noteHeadDescriptions }.joined().map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let restPaths = RestRenderer().paths(forRests: noteSequence.rests)
        
        let articulationMarkPaths = noteSequence.notes.map { note in
            note.articulationMarks.map { makePaths(forArticulationMark: $0, xPos: note.xPosition) }.joined()
        }.joined().toArray()
        
        let tupletMarkPaths = TupletMarksRenderer().paths(forNoteSequence: noteSequence)
        
        // Draw ties
        var tiePaths = [Path]()
        for note in noteSequence.notes {
            for noteHeadDescription in note.noteHeadDescriptions {
                if let tie = noteHeadDescription.tie?.chosenVariation {
                    tiePaths += TieRenderer().paths(forTie: tie,
                                                    inBarRange: barRange,
                                                    canvasWidth: canvasWidth)
                }
            }
        }
        
        // Draw leading ties
        var leadingTiePaths = [Path]()
        for tie in leadingTies {
            leadingTiePaths += TieRenderer().paths(forTie: tie,
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
            return DotRenderer().paths(forDot: dot)
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
            return SharpRenderer().paths(forSharpAtX: x, y: y)
        case .flat:
            return FlatRenderer().paths(forFlatAtX: x, y: y)
        case .natural:
            return NaturalRenderer().paths(forNaturalAtX: x, y: y)
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
