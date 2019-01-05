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
        
        var paths = [Path]()

        // Calculate layout sizes
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        let layoutWidth = displaySize.width / staveSpacing
    
        // Populate note symbols
        NoteSymbolDescriber().process(composition: composition)
        
        // Calculate note times
        NoteTimeCalculator().process(composition: composition)
        
        
        
        
        dump(composition)
        
        
        // Render the stave
        paths += StaveRenderer.stavePaths(forCanvasSize: canvasSize)

        return paths.map { $0.scaled(staveSpacing) }

        
        
        // OLD
//        let symbols = Symbolizer().symbolize(composition: composition)
//        let positionedSymbols = LayoutSolver().solve(symbols: symbols,
//                                                     layoutWidth: layoutWidth,
//                                                     staveCentreY: canvasSize.height/2)
//
//        var paths = [Path]()
//        paths += StaveRenderer.stavePaths(forCanvasSize: canvasSize)
//        paths += makePaths(forSymbols: positionedSymbols, centerY: canvasSize.height/2)
//        return paths.map { $0.scaled(staveSpacing) }
    }
    
    /*
    private func makePaths(forSymbols symbols: [Symbol], centerY: Double) -> [Path] {
        
        var paths = [Path]()
        var noteSymbols = [NoteSymbol]()
        
        for symbol in symbols {
            switch symbol {
            case .barline(let barlineSymbol):
                paths.append(makeBarlinePath(staveCenterY: centerY, xPos: barlineSymbol.xPosition))
            case .note(let noteSymbol):
                noteSymbols.append(noteSymbol)
            }
        }
        
        paths += NoteRenderer.paths(forNotes: noteSymbols)
        
        return paths
    }
    
    func makeNotePath(fromSymbolPath symbolPath: Path, centerY: Double, staveOffset: Int, xPos: Double) -> Path {
        
        // Stave offset must be negative on iOS as y starts at top
        var centerY = centerY - Double(staveOffset)/2
        
        // Subtract half a stave spacing so that the note centered on the pitch line
        centerY -= 0.5
        
        var notePath = symbolPath
        notePath.translate(x: xPos, y: centerY)
        return notePath
    }
    
    func makeBarlinePath(staveCenterY: Double, xPos: Double) -> Path {
        
        var path = Path()
        path.move(to: Point(xPos, staveCenterY + 2))
        path.addLine(to: Point(xPos, staveCenterY - 2))
        path.drawStyle = .stroke
        return path
    }
 */
}
