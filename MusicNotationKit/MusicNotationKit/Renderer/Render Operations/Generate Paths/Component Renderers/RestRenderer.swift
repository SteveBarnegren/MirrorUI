//
//  RestRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class RestRenderer {
    
    private let glyphs: GlyphStore
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forRests rests: [Rest]) -> [Path] {
        return rests.compactMap(path(forRest:))
    }
    
    private func path(forRest rest: Rest) -> Path? {
        
        // Glyph based rests
        if let glyph = glyphs.glyph(forRestStyle: rest.symbolDescription.style) {
            return glyph.path.translated(x: rest.xPosition - glyph.width/2,
                                         y: rest.yPosition)
        }
        
        // Non glyph based rests
        switch rest.symbolDescription.style {
        case .block(let blockStyle):
            
            let width: Double = 1
            let height = blockStyle.height
            let blockStartY = blockStyle.startY
            
            let commands: [Path.Command] = [
                .move(Vector2D(rest.position.x - width/2, blockStartY)),
                .line(Vector2D(rest.position.x - width/2, blockStartY + height)),
                .line(Vector2D(rest.position.x + width/2, blockStartY + height)),
                .line(Vector2D(rest.position.x + width/2, blockStartY)),
                .close
            ]
            
            var path = Path(commands: commands)
            path.drawStyle = .fill
            return path
        default:
            return nil
        }
    }
    
    private func path(forTailedRestStyle tailedRest: TailedRestStyle) -> Path {
        
        let additionalTailsToRender = (tailedRest.numberOfTails-1).constrained(min: 0)
        let additionalTailOffset = 0.5
        
        let stemTopRight = Vector2D(0.27204301075268816, 0.4247311827956989)
        let stemRightSideAngle = -Double.pi/2 - 0.28489090065227207
        let stemLength = 0.9411618564085439 + (Double(additionalTailsToRender) * additionalTailOffset)

        let stemRightXLength = cos(stemRightSideAngle) * stemLength
        let stemRightYLength = sin(stemRightSideAngle) * stemLength
        let stemRightBottom = Vector2D(stemTopRight.x + stemRightXLength, stemTopRight.y + stemRightYLength)
        
        let stemCommands: [Path.Command] = [
            .move(Vector2D(-0.110752688172043, -0.478494623655914)),
            .move(Vector2D(0.14086021505376345, 0.22258064516129028)),
            .curve(Vector2D(-0.08494623655913977, 0.1752688172043011), c1: Vector2D(0.06774193548387097, 0.1967741935483871), c2: Vector2D(-0.00752688172043009, 0.1752688172043011)),
            .curve(Vector2D(-0.27204301075268816, 0.3451612903225807), c1: Vector2D(-0.18387096774193548, 0.1752688172043011), c2: Vector2D(-0.27204301075268816, 0.24623655913978493)),
            .curve(Vector2D(-0.11505376344086021, 0.5), c1: Vector2D(-0.27204301075268816, 0.4311827956989247), c2: Vector2D(-0.20107526881720428, 0.5)),
            .curve(Vector2D(0.005376344086021501, 0.4161290322580645), c1: Vector2D(-0.06129032258064515, 0.5), c2: Vector2D(-0.011827956989247324, 0.467741935483871)),
            .curve(Vector2D(0.08064516129032256, 0.28924731182795704), c1: Vector2D(0.02688172043010756, 0.3559139784946237), c2: Vector2D(0.018279569892473146, 0.28924731182795704)),
            .curve(Vector2D(0.21182795698924733, 0.4247311827956989), c1: Vector2D(0.11505376344086021, 0.28924731182795704), c2: Vector2D(0.1967741935483871, 0.3924731182795699)),
             // top of stem right
            .curve(stemTopRight, c1: Vector2D(0.22473118279569892, 0.4505376344086022), c2: Vector2D(0.26129032258064516, 0.4505376344086022)),
             // bottom of stem right
            .line(stemRightBottom),
            // Double curve through bottom
            .curve(stemRightBottom.adding(x: -0.05806451612903224, y: -0.021505376344086002),
                   c1: stemRightBottom.adding(x: -0.01720430107526877, y: -0.01505376344086018),
                   c2: stemRightBottom.adding(x: -0.03655913978494621, y: -0.021505376344086002)),
            .curve(stemRightBottom.adding(x: -0.1182795698924731, y: 0.0),
                   c1: stemRightBottom.adding(x: -0.07956989247311824, y: -0.021505376344086002),
                   c2: stemRightBottom.adding(x: -0.10107526881720427, y: -0.01505376344086018)),
            // Close stem buttom left to top left
            .close
            ]
        
        let additionalTailCommands: [Path.Command] = [
            .move(Vector2D(-0.110752688172043, -0.478494623655914)),
            .move(Vector2D(0.14086021505376345, 0.22258064516129028)),
            .curve(Vector2D(-0.08494623655913977, 0.1752688172043011), c1: Vector2D(0.06774193548387097, 0.1967741935483871), c2: Vector2D(-0.00752688172043009, 0.1752688172043011)),
            .curve(Vector2D(-0.27204301075268816, 0.3451612903225807), c1: Vector2D(-0.18387096774193548, 0.1752688172043011), c2: Vector2D(-0.27204301075268816, 0.24623655913978493)),
            .curve(Vector2D(-0.11505376344086021, 0.5), c1: Vector2D(-0.27204301075268816, 0.4311827956989247), c2: Vector2D(-0.20107526881720428, 0.5)),
            .curve(Vector2D(0.005376344086021501, 0.4161290322580645), c1: Vector2D(-0.06129032258064515, 0.5), c2: Vector2D(-0.011827956989247324, 0.467741935483871)),
            .curve(Vector2D(0.08064516129032256, 0.28924731182795704), c1: Vector2D(0.02688172043010756, 0.3559139784946237), c2: Vector2D(0.018279569892473146, 0.28924731182795704)),
            .curve(Vector2D(0.21182795698924733, 0.4247311827956989), c1: Vector2D(0.11505376344086021, 0.28924731182795704), c2: Vector2D(0.1967741935483871, 0.3924731182795699)),
            .curve(stemTopRight, c1: Vector2D(0.22473118279569892, 0.4505376344086022), c2: Vector2D(0.26129032258064516, 0.4505376344086022)),
            .close
            ]
        
        var pathCommands = stemCommands
        
        // Add additional tails
        if additionalTailsToRender > 0 {
            
            for i in 1...additionalTailsToRender {
                let translationX = cos(stemRightSideAngle) * additionalTailOffset * Double(i)
                let translationY = sin(stemRightSideAngle) * additionalTailOffset * Double(i)
                let commands = additionalTailCommands.translated(x: translationX, y: translationY)
                pathCommands += commands
            }
        }
        
        var path = Path(commands: pathCommands)
        
        // Translate the path upwards to account for a longer bottom due to additional tail rendering
        if additionalTailsToRender != 0 {
            let translationY = sin(stemRightSideAngle) * additionalTailOffset * Double(additionalTailsToRender)
            path.translate(x: 0, y: -translationY/2)
        }
        
        path.drawStyle = .fill
        return path.scaled(2)
    }
}
