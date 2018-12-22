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

class LayoutSolver {
    
    private enum SpacedToken {
        case token(Token)
        case space(Double)
    }
    
    func solve(tokens: [Token], layoutWidth: Double) -> [PositionedToken] {
        
        // Generate the initial tokens
        var spacedTokens = generateSpacedTokens(fromTokens: tokens)

        // Scale the space to fill the layout width
        let tokensWidth = tokens.map { self.width(forToken: $0) }.sum()
        let layoutSpace = layoutWidth - tokensWidth
        spacedTokens = scaleSpacedTokens(spacedTokens, availableSpace: layoutSpace)
        
        // Create Positioned Tokens
        return generatePositionedTokens(fromSpacedTokens: spacedTokens)
    }
    
    private func generateSpacedTokens(fromTokens tokens: [Token]) -> [SpacedToken] {
        
        var spacedTokens = [SpacedToken]()
        
        for token in tokens {
            switch token {
            case .semibreve:
                spacedTokens.append(.token(token))
                spacedTokens.append(.space(1))
            case .crotchet:
                spacedTokens.append(.token(token))
                spacedTokens.append(.space(0.25))
            case .minim:
                spacedTokens.append(.token(token))
                spacedTokens.append(.space(0.5))
            }
        }
        
        return spacedTokens
    }
    
    private func scaleSpacedTokens(_ spacedTokens: [SpacedToken], availableSpace: Double) -> [SpacedToken] {
        
        // Total up the current space defined in the tokens
        var unscaledTotalSpace: Double = 0
        
        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token:
                break
            case .space(let space):
                unscaledTotalSpace += space
            }
        }
        
        // Scale each space to fill the available space
        var scaledTokens = [SpacedToken]()
        let scale = availableSpace / unscaledTotalSpace

        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token:
                scaledTokens.append(spacedToken)
            case .space(let space):
                scaledTokens.append(.space(space * scale))
            }
        }
        
        return scaledTokens
    }
    
    private func generatePositionedTokens(fromSpacedTokens spacedTokens: [SpacedToken]) -> [PositionedToken] {
        
        var xPos: Double = 0
        
        var positionedTokens = [PositionedToken]()
        
        for spacedToken in spacedTokens {
            switch spacedToken {
            case .token(let token):
                let positionedToken = PositionedToken(token: token, xPos: xPos)
                positionedTokens.append(positionedToken)
                xPos += width(forToken: token)
            case .space(let space):
                xPos += space
            }
        }
        
        return positionedTokens
    }
    
    private func width(forToken token: Token) -> Double {
        
        switch token {
        case .semibreve:
            return 1
        case .crotchet:
            return 1
        case .minim:
            return 1
        }
    }
}
