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
            .move(Point(-0.40594229500793494, -0.43810369839336344)),
            .curve(Point(-0.8198711305231902, 0.0006822075876243838), c1: Point(-0.6373152994690181, -0.3668909590179441), c2: Point(-0.8198711305231902, -0.1733724253936259)),
            .curve(Point(0.6752807109343254, 0.2761465325327329), c1: Point(-0.8198711305231902, 0.4933294770822765), c2: Point(0.2382887400024435, 0.6882831166544896)),
            .curve(Point(-0.40594229500793494, -0.43810369839336405), c1: Point(1.1478348555942364, -0.16952906055707379), c2: Point(0.37664734863491944, -0.6789713419181947)),
            .close,
            .move(Point(0.29985413275057315, -0.31434238387233726)),
            .curve(Point(0.08252281605067535, 0.3730173415288457), c1: Point(0.4285923332454685, -0.11786314186336128), c2: Point(0.30550826919230023, 0.27141853294894747)),
            .curve(Point(-0.3092752083402506, -0.12327399006989698), c1: Point(-0.24493893937713618, 0.5222190290006006), c2: Point(-0.44566141442929347, 0.2679637137350671)),
            .curve(Point(0.29985413275057315, -0.31434238387233726), c1: Point(-0.21493998468806386, -0.39388416753487654), c2: Point(0.1688556246034726, -0.5142715204025433)),
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
    
    static let crotchetRest: Path = {
        
        let commands: [Path.Command] = [
            .move(Point(-0.07132289963611871, 0.5)),
            .move(Point(0.14589187112515656, 0.20309352879998177)),
            .curve(Point(0.11617440277583474, -0.2600607545795094), c1: Point(-0.05828932376610517, -0.029659659116745674), c2: Point(0.0656126936077216, -0.12553736693677991)),
            .line(Point(-0.11908774106275159, 0.08240185785416365)),
            .curve(Point(-0.08603923498084695, 0.49200366912838855), c1: Point(0.016917803438006557, 0.24320514648577685), c2: Point(-0.03754118507191356, 0.3671551303745799)),
            .curve(Point(-0.07132289963611871, 0.5), c1: Point(-0.08606741742207853, 0.4920670796211596), c2: Point(-0.07134923612744958, 0.49991597405146804)),
            .close,
            .move(Point(0.09750504322054346, -0.22183888230805415)),
            .curve(Point(-0.002308412973578783, -0.5), c1: Point(-0.15289510164847742, 0.0024915180363466183), c2: Point(-0.24902926968371866, -0.289898632408993)),
            .curve(Point(0.10976267193612887, -0.2594427136433017), c1: Point(-0.03405479163204185, -0.44551516819147063), c2: Point(-0.12569153523945045, -0.17790090639381118)),
            ]

        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path.scaled(3)
    }()
}
