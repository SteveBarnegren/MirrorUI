import Foundation

class SymbolPaths {
    
    static let semibreve: Path = {
        
        // A semibreve path, where the height is scaled to 1
        let commands: [Path.Command] = [
            .move(Vector2D(-0.40594229500793494, -0.43810369839336344)),
            .curve(Vector2D(-0.8198711305231902, 0.0006822075876243838), c1: Vector2D(-0.6373152994690181, -0.3668909590179441), c2: Vector2D(-0.8198711305231902, -0.1733724253936259)),
            .curve(Vector2D(0.6752807109343254, 0.2761465325327329), c1: Vector2D(-0.8198711305231902, 0.4933294770822765), c2: Vector2D(0.2382887400024435, 0.6882831166544896)),
            .curve(Vector2D(-0.40594229500793494, -0.43810369839336405), c1: Vector2D(1.1478348555942364, -0.16952906055707379), c2: Vector2D(0.37664734863491944, -0.6789713419181947)),
            .close,
            .move(Vector2D(0.29985413275057315, -0.31434238387233726)),
            .curve(Vector2D(0.08252281605067535, 0.3730173415288457), c1: Vector2D(0.4285923332454685, -0.11786314186336128), c2: Vector2D(0.30550826919230023, 0.27141853294894747)),
            .curve(Vector2D(-0.3092752083402506, -0.12327399006989698), c1: Vector2D(-0.24493893937713618, 0.5222190290006006), c2: Vector2D(-0.44566141442929347, 0.2679637137350671)),
            .curve(Vector2D(0.29985413275057315, -0.31434238387233726), c1: Vector2D(-0.21493998468806386, -0.39388416753487654), c2: Vector2D(0.1688556246034726, -0.5142715204025433)),
            .close
        ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path
    }()
    
    static let filledNoteHeadCommands: [Path.Command] = [
        .move(Vector2D(-0.5921144330682797, -0.15151477041915018)),
        .curve(Vector2D(-0.34254560215273067, 0.31313129945094453), c1: Vector2D(-0.5921148200272967, 0.023568706314745835), c2: Vector2D(-0.5089252097221132, 0.17845060061843832)),
        .curve(Vector2D(0.18595334899485438, 0.5), c1: Vector2D(-0.18269012360631914, 0.4377100461912986), c2: Vector2D(-0.0065239355434627555, 0.5)),
        .curve(Vector2D(0.46977656599411954, 0.4040403551819416), c1: Vector2D(0.2936111518492963, 0.5), c2: Vector2D(0.3882187618627124, 0.4680131937546357)),
        .curve(Vector2D(0.592114433068279, 0.15151477041914962), c1: Vector2D(0.551335531002576, 0.3367001992451977), c2: Vector2D(0.5921148200272957, 0.25252500432426783)),
        .curve(Vector2D(0.3425456021527308, -0.3131312994509446), c1: Vector2D(0.5921148200272968, -0.023568706314745835), c2: Vector2D(0.5089252097221137, -0.17845060061843815)),
        .curve(Vector2D(-0.1859533489948541, -0.5), c1: Vector2D(0.18269012360631964, -0.4377100461912978), c2: Vector2D(0.006523935543463089, -0.5)),
        .curve(Vector2D(-0.4697765659941189, -0.40404035518194237), c1: Vector2D(-0.29361115184929615, -0.5), c2: Vector2D(-0.3882187618627123, -0.468013193754636)),
        .curve(Vector2D(-0.5921144330682792, -0.15151477041914968), c1: Vector2D(-0.5513355310025762, -0.3367001992451978), c2: Vector2D(-0.5921148200272961, -0.25252500432426717))
    ]
    
    static let filledNoteHead: Path = {
        var path = Path(commands: filledNoteHeadCommands)
        path.drawStyle = .fill
        return path
    }()
    
    static let openNoteHead: Path = {
        
        let holeCommands: [Path.Command] = [
            .move(Vector2D(-0.5613551633450389, -0.5)),
            .curve(Vector2D(0.2614533679937976, -0.1428573600279716), c1: Vector2D(-0.2896498989069793, -0.5), c2: Vector2D(-0.015380672230583259, -0.38095285872820417)),
            .curve(Vector2D(0.6843919064775543, 0.38888888888888884), c1: Vector2D(0.5434107721074475, 0.09523753059394047), c2: Vector2D(0.6843900822425928, 0.27248567215457353)),
            .curve(Vector2D(0.5921141971085875, 0.5), c1: Vector2D(0.6843900822425928, 0.46296134142077494), c2: Vector2D(0.653631048479044, 0.49999878384335905)),
            .curve(Vector2D(-0.19224487313966038, 0.15873002842766148), c1: Vector2D(0.40243146197230195, 0.49999878384335905), c2: Vector2D(0.14097845882549676, 0.3862425320381264)),
            .curve(Vector2D(-0.6843919064775543, -0.3968255271278941), c1: Vector2D(-0.5203435642510755, -0.06349219379456073), c2: Vector2D(-0.6843924537480427, -0.2486775816725194)),
            .curve(Vector2D(-0.5613551633450389, -0.5), c1: Vector2D(-0.6843924537480428, -0.46560891442817837), c2: Vector2D(-0.643380246575759, -0.5))
            ].scaled(0.62)
        
        var path = Path(commands: filledNoteHeadCommands + holeCommands)
        path.drawStyle = .fill
        return path
    }()
    
    static let crossNoteHead: Path = {
        
        let width = 0.15
        
        // A 'reverse Pythagoras' that gets the x/y offsets required to get the width of
        // the line (which is a 45 degree diagonal and the hypotenuse in this case)
        let offset = sqrt((width*width)/2)
        
        let center = Vector2D(0, 0)
        let topLeft = Vector2D(-0.5, 0.5)
        let topRight = Vector2D(0.5, 0.5)
        let bottomLeft = Vector2D(-0.5, -0.5)
        let bottomRight = Vector2D(0.5, -0.5)
        
        let commands: [Path.Command] = [
            .move(center.adding(y: offset)), // Above Center
            .line(topRight.subtracting(x: offset)), // Top right arm
            .line(topRight.subtracting(y: offset)),
            .line(center.adding(x: offset)), // Right of center
            .line(bottomRight.adding(y: offset)), // Bottom right arm
            .line(bottomRight.subtracting(x: offset)),
            .line(center.subtracting(y: offset)), // Below center
            .line(bottomLeft.adding(x: offset)), // Bottom left arm
            .line(bottomLeft.adding(y: offset)),
            .line(center.subtracting(x: offset)), // left of center
            .line(topLeft.subtracting(y: offset)), // top left arm
            .line(topLeft.adding(x: offset)),
            .close
        ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path
    }()
    
    static let crotchetRest: Path = {
        
        let commands: [Path.Command] = [
            .move(Vector2D(-0.07132289963611871, 0.5)),
            .move(Vector2D(0.14589187112515656, 0.20309352879998177)),
            .curve(Vector2D(0.11617440277583474, -0.2600607545795094), c1: Vector2D(-0.05828932376610517, -0.029659659116745674), c2: Vector2D(0.0656126936077216, -0.12553736693677991)),
            .line(Vector2D(-0.11908774106275159, 0.08240185785416365)),
            .curve(Vector2D(-0.08603923498084695, 0.49200366912838855), c1: Vector2D(0.016917803438006557, 0.24320514648577685), c2: Vector2D(-0.03754118507191356, 0.3671551303745799)),
            .curve(Vector2D(-0.07132289963611871, 0.5), c1: Vector2D(-0.08606741742207853, 0.4920670796211596), c2: Vector2D(-0.07134923612744958, 0.49991597405146804)),
            .close,
            .move(Vector2D(0.09750504322054346, -0.22183888230805415)),
            .curve(Vector2D(-0.002308412973578783, -0.5), c1: Vector2D(-0.15289510164847742, 0.0024915180363466183), c2: Vector2D(-0.24902926968371866, -0.289898632408993)),
            .curve(Vector2D(0.10976267193612887, -0.2594427136433017), c1: Vector2D(-0.03405479163204185, -0.44551516819147063), c2: Vector2D(-0.12569153523945045, -0.17790090639381118))
        ]
        
        var path = Path(commands: commands)
        path.drawStyle = .fill
        return path.scaled(3)
    }()
    
}
