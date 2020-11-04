//
//  NaturalRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NaturalRenderer {
    
    func paths(forNaturalAtX x: Double, y: Double) -> [Path] {
        
        var path = naturalPath.translated(x: x, y: y)
        path.drawStyle = .fill
        return [path]
    }
    
    private let naturalPath: Path = {
        
        let commands: [Path.Command] = [
            .move(Vector2D(0.10912698412698395, 0.25529100529100535)),
            .line(Vector2D(0.10912698412698395, -0.5)),
            .line(Vector2D(0.07473544973544984, -0.5)),
            .line(Vector2D(0.07473544973544984, -0.2169312169312168)),
            .line(Vector2D(-0.10912698412698395, -0.2645502645502644)),
            .line(Vector2D(-0.10912698412698395, 0.5)),
            .line(Vector2D(-0.07605820105820119, 0.5)),
            .line(Vector2D(-0.07605820105820119, 0.2050264550264551)),
            .line(Vector2D(0.10912698412698395, 0.25529100529100535)),
            .close,
            .move(Vector2D(-0.07605820105820119, 0.07804232804232814)),
            .line(Vector2D(-0.07605820105820119, -0.12962962962962954)),
            .line(Vector2D(0.07473544973544984, -0.08994708994708989)),
            .line(Vector2D(0.07473544973544984, 0.11772486772486779)),
            .line(Vector2D(-0.07605820105820119, 0.07804232804232814)),
            .close
        ]
        
        return Path(commands: commands).scaled(2.25)
    }()
}
