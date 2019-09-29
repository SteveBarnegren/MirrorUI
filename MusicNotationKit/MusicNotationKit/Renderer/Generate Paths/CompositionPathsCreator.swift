//
//  CompositionPathsCreator.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 17/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CompositionPathsCreator {
    
    func paths(fromBars bars: [Bar], canvasSize: Size, staveSpacing: Double, displaySize: DisplaySize) -> [Path] {
        
        var paths = bars.map(makePaths(forBar:)).joined().toArray()
        
        // Make the path for the last barline
        if let lastBarline = bars.last?.trailingBarline {
            paths += BarlineRenderer().paths(forBarline: lastBarline)
        }
        
        paths += StaveRenderer.stavePaths(withWidth: canvasSize.width)
        paths = paths.map { $0.scaled(staveSpacing) }.map { $0.translated(x: 0, y: displaySize.height/2) }
        return paths
    }
    
    private func makePaths(forBar bar: Bar) -> [Path] {
        
        let barlinePath = BarlineRenderer().paths(forBarline: bar.leadingBarline)
        let notePaths =  bar.sequences.map(makePaths(forNoteSequence:)).joined().toArray()
        return barlinePath + notePaths
    }
    
    private func makePaths(forNoteSequence noteSequence: NoteSequence) -> [Path] {
        let notePaths = NoteRenderer().paths(forNotes: noteSequence.notes)
        let noteSymbolPaths = noteSequence.notes.map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()
        let restPaths = RestRenderer().paths(forRests: noteSequence.rests)
        
        return notePaths + noteSymbolPaths + restPaths
    }
    
    // Render Symbols
    
    private func makePaths(forSymbol symbol: AdjacentLayoutItem) -> [Path] {
        
        switch symbol {
        case let dot as DotSymbol:
            return DotRenderer().paths(forDot: dot)
        case let sharp as SharpSymbol:
            return SharpRenderer().paths(forSharp: sharp)
        case let flat as FlatSymbol:
            return FlatRenderer().paths(forFlat: flat)
        case let natural as NaturalSymbol:
            return NaturalRenderer().paths(forNatural: natural)
        default:
            fatalError("Unknown symbol type: \(symbol)")
        }
    }
    
}

