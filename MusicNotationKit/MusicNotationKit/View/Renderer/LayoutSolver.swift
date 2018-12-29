//
//  LayoutSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct PositionedToken {
    let token: Token
    let xPos: Double
}

struct PositionedItem<T> {
    let item: T
    let xPos: Double
}

class LayoutSolver {
    
    private enum SpacedToken {
        case token(Token)
        case rhythmicSpace(Double)
        case fixedSpace(Double)
    }
    
    func solve(tokens: [Token], layoutWidth: Double) -> [PositionedItem<Token>] {
        
        // Generate the initial tokens
        var spacedTokens = generateSpacedTokens(fromTokens: tokens)

        // Scale the space to fill the layout width
        spacedTokens = scaleSpacedTokens(spacedTokens, layoutWidth: layoutWidth)
        
        // Create Positioned Tokens
        return generatePositionedTokens(fromSpacedTokens: spacedTokens)
    }
    
    private func generateSpacedTokens(fromTokens tokens: [Token]) -> [SpacedToken] {
        
        var spacedTokens = [SpacedToken]()
        
        for (index, token) in tokens.enumerated() {
            let isLast = index == tokens.count-1
            
            switch token {
            case .note(let noteToken):
                spacedTokens.append(.token(token))
                spacedTokens.append(.rhythmicSpace(noteToken.duration))
            case .barline:
                spacedTokens.append(.token(token))
                if !isLast {
                    spacedTokens.append(.fixedSpace(1))
                }
            }
        }
        
        return spacedTokens
    }
    
    private func scaleSpacedTokens(_ spacedTokens: [SpacedToken],
                                   layoutWidth: Double) -> [SpacedToken] {
        
        // Get the space taken up bu tokens and fixed spaces
        var fixedSpace: Double = 0
        
        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token(let token):
                fixedSpace += width(forToken: token)
            case .fixedSpace(let space):
                fixedSpace += space
            case .rhythmicSpace:
                break
            }
        }
        
        // Total up the available scalable space
        var scalableSpace: Double = 0
        
        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token, .fixedSpace:
                break
            case .rhythmicSpace(let space):
                scalableSpace += space
            }
        }
        
        // Scale each space to fill the available space
        var scaledTokens = [SpacedToken]()
        let availableSpace = layoutWidth - fixedSpace
        let scale = availableSpace / scalableSpace

        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token:
                scaledTokens.append(spacedToken)
            case .rhythmicSpace(let space):
                scaledTokens.append(.rhythmicSpace(space * scale))
            case .fixedSpace(let space):
                scaledTokens.append(.fixedSpace(space))
            }
        }
        
        return scaledTokens
    }
    
    private func generatePositionedTokens(fromSpacedTokens spacedTokens: [SpacedToken]) -> [PositionedItem<Token>] {
        
        var xPos: Double = 0
        
        var positionedTokens = [PositionedItem<Token>]()
        
        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token(let token):
                let positionedToken = PositionedItem(item: token, xPos: xPos)
                positionedTokens.append(positionedToken)
                xPos += width(forToken: token)
            case .rhythmicSpace(let space):
                xPos += space
            case .fixedSpace(let space):
                xPos += space
            }
        }
        
        return positionedTokens
    }
    
    private func width(forToken token: Token) -> Double {
        
        switch token {
        case .note:
            return 1
        case .barline:
            return 0
        }
    }
}
