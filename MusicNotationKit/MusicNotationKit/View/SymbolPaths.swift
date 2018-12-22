//
//  SymbolPaths.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

class SymbolPaths {
    
    static let semibreve: Path = {
        
        // A semibreve path, where the height is scaled to 1
        let commands: [Path.Command] = [
            .move(Point(0.413928835515255, 0.9381036983933635)),
            .curve(Point(0.0, 0.4993177924123759), c1: Point(0.18255583105417203, 0.8668909590179441), c2: Point(0.0, 0.6733724253936261)),
            .curve(Point(1.4951518414575147, 0.2238534674672675), c1: Point(0.0, 0.006670522917724008), c2: Point(1.0581598705256332, -0.188283116654489)),
            .curve(Point(0.413928835515255, 0.938103698393364), c1: Point(1.9677059861174255, 0.669529060557074), c2: Point(1.1965184791581092, 1.1789713419181946)),
            .close,
            .move(Point(1.1197252632737626, 0.8143423838723374)),
            .curve(Point(0.9023939465738651, 0.1269826584711547), c1: Point(1.248463463768658, 0.6178631418633614), c2: Point(1.1253793997154897, 0.22858146705105295)),
            .curve(Point(0.5105959221829393, 0.6232739900698971), c1: Point(0.5749321911460537, -0.022219029000600073), c2: Point(0.3742097160938965, 0.23203628626493328)),
            .curve(Point(1.1197252632737626, 0.8143423838723374), c1: Point(0.6049311458351261, 0.8938841675348765), c2: Point(0.9887267551266623, 1.0142715204025434)),
            .close,
            ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path
    }()
    
    static let filledNoteHead: Path = {
        
        // A filled note head, for a crotchet, quaver, semiquaver
        
        let scaler = 0.9
        let size = Size(width: 1.5 * scaler, height: 1 * scaler)
        let point = Point(size.width/2, 0.5)
        
        var path = Path()
        path.addOval(atPoint: point, withSize: size, rotation: -0.3)
        path.drawStyle = .fill
        return path
    }()
    
    static let openNoteHead: Path = {
        
        // A filled note head, for a crotchet, quaver, semiquaver
        
        let scaler = 0.9
        let size = Size(width: 1.5 * scaler, height: 1 * scaler)
        let point = Point(size.width/2, 0.5)
        
        var path = Path()
        path.addOval(atPoint: point, withSize: size, rotation: -0.3)
        path.drawStyle = .stroke
        return path
    }()
}
