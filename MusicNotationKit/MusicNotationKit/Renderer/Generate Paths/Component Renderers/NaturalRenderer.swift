//
//  NaturalRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NaturalRenderer {
    
    func paths(forNatural natural: NaturalSymbol) -> [Path] {
        
        var path = naturalPath.translated(x: natural.position.x, y: natural.position.y)
        path.drawStyle = .fill
        return [path]
    }
    
    private let naturalPath: Path = {
        
        let commands: [Path.Command] = [
            .move(Point(0.10912698412698395, 0.25529100529100535)),
            .line(Point(0.10912698412698395, -0.5)),
            .line(Point(0.07473544973544984, -0.5)),
            .line(Point(0.07473544973544984, -0.2169312169312168)),
            .line(Point(-0.10912698412698395, -0.2645502645502644)),
            .line(Point(-0.10912698412698395, 0.5)),
            .line(Point(-0.07605820105820119, 0.5)),
            .line(Point(-0.07605820105820119, 0.2050264550264551)),
            .line(Point(0.10912698412698395, 0.25529100529100535)),
            .close,
            .move(Point(-0.07605820105820119, 0.07804232804232814)),
            .line(Point(-0.07605820105820119, -0.12962962962962954)),
            .line(Point(0.07473544973544984, -0.08994708994708989)),
            .line(Point(0.07473544973544984, 0.11772486772486779)),
            .line(Point(-0.07605820105820119, 0.07804232804232814)),
            .close,
        ]
        
        return Path(commands: commands).scaled(2.25)
    }()
}


