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
    
    static let quaverRest: Path = {
        
        let commands: [Path.Command] = [
            .move(Point(-0.110752688172043, -0.478494623655914)),
            .move(Point(0.14086021505376345, 0.22258064516129028)),
            .curve(Point(-0.08494623655913977, 0.1752688172043011), c1: Point(0.06774193548387097, 0.1967741935483871), c2: Point(-0.00752688172043009, 0.1752688172043011)),
            .curve(Point(-0.27204301075268816, 0.3451612903225807), c1: Point(-0.18387096774193548, 0.1752688172043011), c2: Point(-0.27204301075268816, 0.24623655913978493)),
            .curve(Point(-0.11505376344086021, 0.5), c1: Point(-0.27204301075268816, 0.4311827956989247), c2: Point(-0.20107526881720428, 0.5)),
            .curve(Point(0.005376344086021501, 0.4161290322580645), c1: Point(-0.06129032258064515, 0.5), c2: Point(-0.011827956989247324, 0.467741935483871)),
            .curve(Point(0.08064516129032256, 0.28924731182795704), c1: Point(0.02688172043010756, 0.3559139784946237), c2: Point(0.018279569892473146, 0.28924731182795704)),
            .curve(Point(0.21182795698924733, 0.4247311827956989), c1: Point(0.11505376344086021, 0.28924731182795704), c2: Point(0.1967741935483871, 0.3924731182795699)),
            .curve(Point(0.27204301075268816, 0.4247311827956989), c1: Point(0.22473118279569892, 0.4505376344086022), c2: Point(0.26129032258064516, 0.4505376344086022)),
            .line(Point(0.00752688172043009, -0.478494623655914)),
            .curve(Point(-0.05053763440860215, -0.5), c1: Point(-0.009677419354838679, -0.4935483870967742), c2: Point(-0.02903225806451612, -0.5)),
            .curve(Point(-0.110752688172043, -0.478494623655914), c1: Point(-0.07204301075268815, -0.5), c2: Point(-0.09354838709677418, -0.4935483870967742)),
            .close,
            ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path.scaled(2)
    }()
}
