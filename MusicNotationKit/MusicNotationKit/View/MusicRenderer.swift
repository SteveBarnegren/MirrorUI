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
        
        let layoutWidth = displaySize.width / staveSpacing
        
        let tokens = Tokenizer().tokenize(composition: composition)
        let positionedTokens = LayoutSolver().solve(tokens: tokens,
                                                    layoutWidth: layoutWidth,
                                                    staveSpacing: staveSpacing)
        
        var paths = [Path]()
        paths += makeStavePaths(forDisplaySize: displaySize)
        paths += makePaths(forTokens: positionedTokens, centerY: displaySize.height/2)
        //paths += makeBarEndPaths(forDisplaySize: displaySize)
        //paths += makeCompositionPaths(forDisplaySize: displaySize)
        return paths
    }
    
    private func makeStavePaths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        let midY = displaySize.height/2
        let numberOfLines = 5
        let staveHeight = Double(numberOfLines-1) * staveSpacing

        var paths = [Path]()
        
        var y = midY - staveHeight/2
        for _ in (0..<numberOfLines) {
            
            var path = Path()
            path.drawStyle = .stroke
            path.move(to: Point(0, y))
            path.addLine(to: Point(displaySize.width, y))
            paths.append(path)
            y += staveSpacing
        }
        
        return paths
    }
    
    private func makeBarEndPaths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        let midY = displaySize.height/2
        let numberOfLines = 5
        let staveHeight = Double(numberOfLines-1) * staveSpacing
        
        // Draw the left line
        var leftPath = Path()
        leftPath.move(to: Point(0, midY - staveHeight/2))
        leftPath.addLine(to: Point(0, midY + staveHeight/2))
        
        // Draw the right line
        var rightPath = Path()
        rightPath.move(to: Point(displaySize.width, midY - staveHeight/2))
        rightPath.addLine(to: Point(displaySize.width, midY + staveHeight/2))
        
        return [leftPath, rightPath]
        
    }
    
    private func makePaths(forTokens positionedTokens: [PositionedToken], centerY: Double) -> [Path] {
        
        var paths = [Path]()
        
        for positionedToken in positionedTokens {
            paths.append(makePath(forToken: positionedToken.token,
                                  centerY: centerY,
                                  xPos: positionedToken.xPos * staveSpacing))
        }
        
        return paths
    }
    
    func makePath(forToken token: Token, centerY: Double, xPos: Double) -> Path {
        
        switch token {
        case .semibreve(let pitch):
            return makeNotePath(fromSymbolPath: SymbolPaths.filledNoteHead,
                                centerY: centerY,
                                staveOffset: pitch.staveOffset,
                                xPos: xPos)
        case .crotchet(let pitch):
            return makeNotePath(fromSymbolPath: SymbolPaths.filledNoteHead,
                                centerY: centerY,
                                staveOffset: pitch.staveOffset,
                                xPos: xPos)
        case .minim(let pitch):
            return makeNotePath(fromSymbolPath: SymbolPaths.openNoteHead,
                                centerY: centerY,
                                staveOffset: pitch.staveOffset,
                                xPos: xPos)
        case .barline:
            return makeBarlinePath(centerY: centerY, xPos: xPos)
        }
    }
    
    func makeNotePath(fromSymbolPath symbolPath: Path, centerY: Double, staveOffset: Int, xPos: Double) -> Path {
        
        // Stave offset must be negative on iOS as y starts at top
        var centerY = centerY - (Double(staveOffset) * staveSpacing/2)
        
        // Subtract half a stave spacing so that the note centered on the pitch line
        centerY -= staveSpacing/2
        
        var notePath = symbolPath
        notePath.scale(staveSpacing)
        notePath.translate(x: xPos, y: centerY)
        return notePath
    }
    
    func makeBarlinePath(centerY: Double, xPos: Double) -> Path {
        
        var path = Path()
        path.move(to: Point(xPos, centerY + staveSpacing*2))
        path.addLine(to: Point(xPos, centerY - staveSpacing*2))
        path.drawStyle = .stroke
        return path
    }
}
