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
    let staveSpacing: Double = 20
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func paths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        
        let layoutWidth = displaySize.width / staveSpacing
        
        let tokens = Tokenizer().tokenize(composition: composition)
        let positionedTokens = LayoutSolver().solve(tokens: tokens,
                                                    layoutWidth: layoutWidth)
        
        var paths = [Path]()
        paths += StaveRenderer.stavePaths(forCanvasSize: canvasSize)
        paths += makePaths(forTokens: positionedTokens, centerY: canvasSize.height/2)
        return paths.map { $0.scaled(staveSpacing) }
    }
    
    private func makePaths(forTokens positionedTokens: [PositionedToken], centerY: Double) -> [Path] {
        
        var paths = [Path]()
        
        for positionedToken in positionedTokens {
            paths += makePaths(forToken: positionedToken.token,
                               centerY: centerY,
                               xPos: positionedToken.xPos)
        }
        
        return paths
    }
    
    func makePaths(forToken token: Token, centerY: Double, xPos: Double) -> [Path] {
        
        switch token {
        case .semibreve(let pitch):
            return [makeNotePath(fromSymbolPath: SymbolPaths.filledNoteHead,
                                 centerY: centerY,
                                 staveOffset: pitch.staveOffset,
                                 xPos: xPos)]
        case .crotchet(let pitch):
            return CrotchetRenderer.crotchetPaths(withPitch: pitch,
                                                  staveCenterY: centerY,
                                                  xPos: xPos)
        case .minim(let pitch):
            return [makeNotePath(fromSymbolPath: SymbolPaths.openNoteHead,
                                 centerY: centerY,
                                 staveOffset: pitch.staveOffset,
                                 xPos: xPos)]
        case .barline:
            return [makeBarlinePath(staveCenterY: centerY, xPos: xPos)]
        }
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
}
