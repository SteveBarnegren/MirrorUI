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
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func paths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        // Calculate layout sizes
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        let layoutWidth = displaySize.width / staveSpacing
        print("Layout width: \(layoutWidth)")
    
        // Populate note symbols
        NoteSymbolDescriber().process(composition: composition)
        
        // Calculate note times
        NoteTimeCalculator().process(composition: composition)
        
        // Populate note beams
        NoteBeamDescriber().process(composition: composition)
        
        // Calculate width constraints
        WidthConstraintsCalculator().process(composition: composition)
        
        // Solve X Positions
        HorizontalPositioner().process(composition: composition, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositioner().process(composition: composition, staveCenterY: canvasSize.height/2)
        
        // Make paths
        var paths = makePaths(forComposition: composition)
        paths += StaveRenderer.stavePaths(forCanvasSize: canvasSize)

        dump(composition)
        return paths.map { $0.scaled(staveSpacing) }
    }
    
    private func makePaths(forComposition composition: Composition) -> [Path] {
        return composition.bars.map(makePaths(forBar:)).joined().toArray()
    }
    
    private func makePaths(forBar bar: Bar) -> [Path] {
        
        let barlinePath = BarlineRenderer().paths(forBarline: bar.leadingBarline, staveCenterY: 10)
        let notePaths =  bar.sequences.map(makePaths(forNoteSequence:)).joined().toArray()
        return barlinePath + notePaths
    }
    
    private func makePaths(forNoteSequence noteSequence: NoteSequence) -> [Path] {
        return NoteRenderer().paths(forNotes: noteSequence.notes)
    }
}
