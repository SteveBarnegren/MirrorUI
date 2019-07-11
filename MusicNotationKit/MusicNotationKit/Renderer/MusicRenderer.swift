//
//  MusicRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

typealias DisplaySize = Vector2<Double>

class MusicRenderer {
    
    let composition: Composition
    let staveSpacing: Double = 8
    
    var _generateConstraintsDebugInformation = false
    var _constraintsDebugInformation: ConstraintsDebugInformation?
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func paths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        // Calculate layout sizes
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        let layoutWidth = displaySize.width / staveSpacing
        print("Layout width: \(layoutWidth)")
    
        // Populate note symbols
        GenerateSymbolDescriptionsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Calculate note times
        CalculatePlayableItemTimesRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Populate note beams
        GenerateBeamDescriptionsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Solve X Positions
        HorizontalPositionerRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositionerRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Make paths
        var paths = makePaths(forComposition: composition)
        paths += StaveRenderer.stavePaths(withWidth: canvasSize.width)

        //dump(composition)
        paths = paths.map { $0.scaled(staveSpacing) }.map { $0.translated(x: 0, y: displaySize.height/2) }
        
        if _generateConstraintsDebugInformation {
            _constraintsDebugInformation = ConstraintsDebugInformationGenerator().debugInformation(fromComposition: composition, scale: staveSpacing)
        }
        
        return paths
    }
    
    private func makePaths(forComposition composition: Composition) -> [Path] {
        return composition.bars.map(makePaths(forBar:)).joined().toArray()
    }
    
    private func makePaths(forBar bar: Bar) -> [Path] {
        
        let barlinePath = BarlineRenderer().paths(forBarline: bar.leadingBarline)
        let notePaths =  bar.sequences.map(makePaths(forNoteSequence:)).joined().toArray()
        var paths = barlinePath + notePaths
        
        if let trailingBarline = bar.trailingBarline {
            paths += BarlineRenderer().paths(forBarline: trailingBarline)
        }
        
        return paths
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
        default:
            fatalError("Unknown symbol type: \(symbol)")
        }
    }
}
