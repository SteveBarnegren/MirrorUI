//
//  RestRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class RestRenderer {
    
    func paths(forRests rests: [Rest]) -> [Path] {
        return rests.compactMap(path(forRest:))
    }
    
    private func path(forRest rest: Rest) -> Path? {
        
        switch rest.symbolDescription.style {
        case .none:
            return nil
        case .minim:
            
            let width: Double = 1
            let height: Double = 0.5
            
            var path = Path()
            path.move(to: Point(rest.position.x - width/2, 0))
            path.addLine(to: Point(rest.position.x - width/2, height))
            path.addLine(to: Point(rest.position.x + width/2, height))
            path.addLine(to: Point(rest.position.x + width/2, 0))
            path.close()
            path.drawStyle = .fill
            return path
        case .crotchet:
            
            var path = SymbolPaths.crotchetRest
            path.translate(x: rest.position.x, y: 0)
            return path
        case .quaver:
            
            var path = SymbolPaths.quaverRest
            path.translate(x: rest.position.x, y: 0)
            return path
        }
    }
}
