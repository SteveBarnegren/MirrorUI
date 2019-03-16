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
        case .tailed(let tailedRest):
            
            var path = self.path(forTailedRest: tailedRest)
            path.translate(x: rest.position.x, y: 0)
            return path
        }
    }
    
//    private func path(forTailedRest tailedRest: TailedRest) -> Path {
//
//        let commands: [Path.Command] = [
//            .move(Point(-0.110752688172043, -0.478494623655914)),
//            .move(Point(0.14086021505376345, 0.22258064516129028)),
//            .curve(Point(-0.08494623655913977, 0.1752688172043011), c1: Point(0.06774193548387097, 0.1967741935483871), c2: Point(-0.00752688172043009, 0.1752688172043011)),
//            .curve(Point(-0.27204301075268816, 0.3451612903225807), c1: Point(-0.18387096774193548, 0.1752688172043011), c2: Point(-0.27204301075268816, 0.24623655913978493)),
//            .curve(Point(-0.11505376344086021, 0.5), c1: Point(-0.27204301075268816, 0.4311827956989247), c2: Point(-0.20107526881720428, 0.5)),
//            .curve(Point(0.005376344086021501, 0.4161290322580645), c1: Point(-0.06129032258064515, 0.5), c2: Point(-0.011827956989247324, 0.467741935483871)),
//            .curve(Point(0.08064516129032256, 0.28924731182795704), c1: Point(0.02688172043010756, 0.3559139784946237), c2: Point(0.018279569892473146, 0.28924731182795704)),
//            .curve(Point(0.21182795698924733, 0.4247311827956989), c1: Point(0.11505376344086021, 0.28924731182795704), c2: Point(0.1967741935483871, 0.3924731182795699)),
//            .curve(Point(0.27204301075268816, 0.4247311827956989), c1: Point(0.22473118279569892, 0.4505376344086022), c2: Point(0.26129032258064516, 0.4505376344086022)),
//            .line(Point(0.00752688172043009, -0.478494623655914)),
//            .curve(Point(-0.05053763440860215, -0.5), c1: Point(-0.009677419354838679, -0.4935483870967742), c2: Point(-0.02903225806451612, -0.5)),
//            .curve(Point(-0.110752688172043, -0.478494623655914), c1: Point(-0.07204301075268815, -0.5), c2: Point(-0.09354838709677418, -0.4935483870967742)),
//            .close,
//            ]
//
//        var path = Path(commands: commands)
//        path.drawStyle = .fill
//        return path.scaled(2)
//    }
    
    private func path(forTailedRest tailedRest: TailedRest) -> Path {
        
        let stemTopRight = Point(0.27204301075268816, 0.4247311827956989)
        let stemRightSideAngle = -Double.pi/2 - 0.28489090065227207

        //let stemLength = 0.9411618564085439
        let stemLength = 2.0

        let stemRightXLength = cos(stemRightSideAngle) * stemLength
        let stemRightYLength = sin(stemRightSideAngle) * stemLength
        let stemRightBottom = Point(stemTopRight.x + stemRightXLength, stemTopRight.y + stemRightYLength)
        
        let commands: [Path.Command] = [
            .move(Point(-0.110752688172043, -0.478494623655914)),
            .move(Point(0.14086021505376345, 0.22258064516129028)),
            .curve(Point(-0.08494623655913977, 0.1752688172043011), c1: Point(0.06774193548387097, 0.1967741935483871), c2: Point(-0.00752688172043009, 0.1752688172043011)),
            .curve(Point(-0.27204301075268816, 0.3451612903225807), c1: Point(-0.18387096774193548, 0.1752688172043011), c2: Point(-0.27204301075268816, 0.24623655913978493)),
            .curve(Point(-0.11505376344086021, 0.5), c1: Point(-0.27204301075268816, 0.4311827956989247), c2: Point(-0.20107526881720428, 0.5)),
            .curve(Point(0.005376344086021501, 0.4161290322580645), c1: Point(-0.06129032258064515, 0.5), c2: Point(-0.011827956989247324, 0.467741935483871)),
            .curve(Point(0.08064516129032256, 0.28924731182795704), c1: Point(0.02688172043010756, 0.3559139784946237), c2: Point(0.018279569892473146, 0.28924731182795704)),
            .curve(Point(0.21182795698924733, 0.4247311827956989), c1: Point(0.11505376344086021, 0.28924731182795704), c2: Point(0.1967741935483871, 0.3924731182795699)),
             // top of stem right
            .curve(stemTopRight, c1: Point(0.22473118279569892, 0.4505376344086022), c2: Point(0.26129032258064516, 0.4505376344086022)),
             // bottom of stem right
            .line(stemRightBottom),
            //.line(Point(0.00752688172043009, -0.478494623655914 - stemLength)),
            // Double curve through bottom
            .curve(Point(-0.05053763440860215, -0.5), c1: Point(-0.009677419354838679, -0.4935483870967742), c2: Point(-0.02903225806451612, -0.5)),
            .curve(Point(-0.110752688172043, -0.478494623655914), c1: Point(-0.07204301075268815, -0.5), c2: Point(-0.09354838709677418, -0.4935483870967742)),
            // Close stem buttom left to top left
            .close,
            ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path.scaled(2)
    }
    
    // AC = 0.9032258065
    // BC = 0.264516129
    // Stem length =
    
    
    
}
