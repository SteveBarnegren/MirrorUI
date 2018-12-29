//
//  LayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct PositionedSymbol {
    let symbol: Symbol
    let xPos: Double
}

struct PositionedItem<T> {
    let item: T
    let xPos: Double
}

class LayoutSolver {
    
    private enum SpacedSymbol {
        case symbol(Symbol)
        case rhythmicSpace(Double)
        case fixedSpace(Double)
    }
    
    func solve(symbols: [Symbol], layoutWidth: Double) -> [PositionedItem<Symbol>] {
        
        // Generate the initial symbols
        var spacedSymbols = generateSpacedSymbols(fromSymbols: symbols)

        // Scale the space to fill the layout width
        spacedSymbols = scaleSpacedSymbols(spacedSymbols, layoutWidth: layoutWidth)
        
        // Create Positioned Symbols
        return generatePositionedSymbols(fromSpacedSymbols: spacedSymbols)
    }
    
    private func generateSpacedSymbols(fromSymbols symbols: [Symbol]) -> [SpacedSymbol] {
        
        var spacedSymbols = [SpacedSymbol]()
        
        for (index, symbol) in symbols.enumerated() {
            let isLast = index == symbols.count-1
            
            switch symbol {
            case .note(let noteSymbol):
                spacedSymbols.append(.symbol(symbol))
                spacedSymbols.append(.rhythmicSpace(noteSymbol.duration))
            case .barline:
                spacedSymbols.append(.symbol(symbol))
                if !isLast {
                    spacedSymbols.append(.fixedSpace(1))
                }
            }
        }
        
        return spacedSymbols
    }
    
    private func scaleSpacedSymbols(_ spacedSymbols: [SpacedSymbol],
                                    layoutWidth: Double) -> [SpacedSymbol] {
        
        // Get the space taken up by symbols and fixed spaces
        var fixedSpace: Double = 0
        
        for spacedSymbol in spacedSymbols {
            switch spacedSymbol {
            case .symbol(let symbol):
                fixedSpace += width(forSymbol: symbol)
            case .fixedSpace(let space):
                fixedSpace += space
            case .rhythmicSpace:
                break
            }
        }
        
        // Total up the available scalable space
        var scalableSpace: Double = 0
        
        for spacedSymbol in spacedSymbols {
            switch spacedSymbol {
            case .symbol, .fixedSpace:
                break
            case .rhythmicSpace(let space):
                scalableSpace += space
            }
        }
        
        // Scale each space to fill the available space
        var scaledSymbols = [SpacedSymbol]()
        let availableSpace = layoutWidth - fixedSpace
        let scale = availableSpace / scalableSpace

        for spacedSymbol in spacedSymbols {
            switch spacedSymbol {
            case .symbol:
                scaledSymbols.append(spacedSymbol)
            case .rhythmicSpace(let space):
                scaledSymbols.append(.rhythmicSpace(space * scale))
            case .fixedSpace(let space):
                scaledSymbols.append(.fixedSpace(space))
            }
        }
        
        return scaledSymbols
    }
    
    private func generatePositionedSymbols(fromSpacedSymbols spacedSymbols: [SpacedSymbol]) -> [PositionedItem<Symbol>] {
        
        var xPos: Double = 0
        
        var positionedSymbols = [PositionedItem<Symbol>]()
        
        for spacedSymbol in spacedSymbols {
            switch spacedSymbol {
            case .symbol(let symbol):
                let positionedSymbol = PositionedItem(item: symbol, xPos: xPos)
                positionedSymbols.append(positionedSymbol)
                xPos += width(forSymbol: symbol)
            case .rhythmicSpace(let space):
                xPos += space
            case .fixedSpace(let space):
                xPos += space
            }
        }
        
        return positionedSymbols
    }
    
    private func width(forSymbol symbol: Symbol) -> Double {
        
        switch symbol {
        case .note:
            return 1
        case .barline:
            return 0
        }
    }
}
