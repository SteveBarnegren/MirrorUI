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
        
        var paths = [Path]()
        paths += makeStavePaths(forDisplaySize: displaySize)
        paths += makeBarEndPaths(forDisplaySize: displaySize)
        paths += makeCompositionPaths(forDisplaySize: displaySize)
        return paths
    }
    
    private func makeStavePaths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        let midY = displaySize.height/2
        let numberOfLines = 5
        let staveHeight = Double(numberOfLines-1) * staveSpacing

        var paths = [Path]()
        
        var y = midY - staveHeight/2
        for _ in (0..<numberOfLines) {
            
            let path = Path(style: .stroke)
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
        let leftPath = Path()
        leftPath.move(to: Point(0, midY - staveHeight/2))
        leftPath.addLine(to: Point(0, midY + staveHeight/2))
        
        // Draw the right line
        let rightPath = Path()
        rightPath.move(to: Point(displaySize.width, midY - staveHeight/2))
        rightPath.addLine(to: Point(displaySize.width, midY + staveHeight/2))
        
        return [leftPath, rightPath]
    }
    
    private func makeCompositionPaths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        var paths = [Path]()
        
        for note in composition.notes {
            switch note.value {
            case .whole:
                paths.append(
                    makeNotePath(fromSymbolPath: SymbolPaths.semibreve, displaySize: displaySize, staveOffset: 0, xPos: 0)
                )
            }
        }
        
        return paths
    }
    
    func makeNotePath(fromSymbolPath symbolPath: Path, displaySize: DisplaySize, staveOffset: Int, xPos: Double) -> Path {
        
        let centerY = displaySize.height/2 + (Double(staveOffset) * staveSpacing/2)
        let scale = staveSpacing
        
        func transformPoint(_ p: Point) -> Point {
            return Point(xPos + (p.x * scale), centerY + (p.y * scale))
        }
        
        var newCommands = [Path.Command]()
        
        for command in symbolPath.commands {
            switch command {
            case .move(let p):
                newCommands.append(.move(transformPoint(p)))
            case .line(let p):
                newCommands.append(.line(transformPoint(p)))
            case .curve(let p, let c1, let c2):
                newCommands.append(.curve(transformPoint(p), c1: transformPoint(c1), c2: transformPoint(c2)))
            case .close:
                newCommands.append(.close)
            }
        }
        
        return Path(style: symbolPath.drawStyle, commands: newCommands)
    }
    
}
