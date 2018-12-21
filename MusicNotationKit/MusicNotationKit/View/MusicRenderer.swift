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
    let staveSpacing: Double = 40
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func paths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        let layoutWidth = displaySize.width / staveSpacing
        
        let tokens = Tokenizer().tokenize(composition: composition)
        let positionedTokens = LayoutSolver().solve(tokens: tokens, layoutWidth: layoutWidth)
        
        var paths = [Path]()
        paths += makeStavePaths(forDisplaySize: displaySize)
        paths += makePaths(forTokens: positionedTokens, displaySize: displaySize)
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
    
    private func makePaths(forTokens positionedTokens: [PositionedToken], displaySize: DisplaySize) -> [Path] {
        
        var paths = [Path]()
        
        for positionedToken in positionedTokens {
            paths.append(makePath(forToken: positionedToken.token,
                                  displaySize: displaySize,
                                  xPos: positionedToken.xPos * staveSpacing))
        }
        
        return paths
    }
    
    func makePath(forToken token: Token, displaySize: DisplaySize, xPos: Double) -> Path {
        
        switch token {
        case .semibreve:
            return makeNotePath(fromSymbolPath: SymbolPaths.filledNoteHead,
                                displaySize: displaySize,
                                staveOffset: 0,
                                xPos: xPos)
        case .crotchet:
            return makeNotePath(fromSymbolPath: SymbolPaths.filledNoteHead,
                                displaySize: displaySize,
                                staveOffset: 0,
                                xPos: xPos)
        case .minim:
            return makeNotePath(fromSymbolPath: SymbolPaths.openNoteHead,
                                displaySize: displaySize,
                                staveOffset: 0,
                                xPos: xPos)
        }
    }
    
    func makeNotePath(fromSymbolPath symbolPath: Path, displaySize: DisplaySize, staveOffset: Int, xPos: Double) -> Path {
        
        let centerY = displaySize.height/2 + (Double(staveOffset) * staveSpacing/2)
        
        var notePath = symbolPath
        notePath.scale(staveSpacing)
        notePath.translate(x: xPos, y: centerY)
        return notePath
    }
    
    
    
}
