//
//  SharpRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 28/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class SharpRenderer {
    
    func paths(forSharpAtX x: Double, y: Double) -> [Path] {
        
        var path = sharpPath.translated(x: x, y: y)
        path.drawStyle = .fill
        return [path]
    }
    
    private let sharpPath: Path = {

        let commands: [Path.Command] = [
            .move(Vector2D(-0.052140362172335, -0.13971281411866093)),
            .line(Vector2D(-0.052140362172335, 0.10796345065868096)),
            .line(Vector2D(0.05049816175399524, 0.13702740180969686)),
            .line(Vector2D(0.05049816175399524, -0.10938510525487782)),
            .line(Vector2D(-0.052140362172335, -0.13971281411866093)),
            .close,
            .move(Vector2D(0.14995485955334395, -0.0797945883902087)),
            .line(Vector2D(0.0793908880097417, -0.1005393839108315)),
            .line(Vector2D(0.0793908880097417, 0.1458731231537429)),
            .line(Vector2D(0.14995485955334395, 0.1660914986220442)),
            .line(Vector2D(0.14995485955334395, 0.26844742499898055)),
            .line(Vector2D(0.0793908880097417, 0.24822904953067937)),
            .line(Vector2D(0.0793908880097417, 0.5)),
            .line(Vector2D(0.050498161753995435, 0.5)),
            .line(Vector2D(0.050498161753995435, 0.24059450215870115)),
            .line(Vector2D(-0.052140362172334795, 0.21031952269694887)),
            .line(Vector2D(-0.052140362172334795, 0.45514024273004294)),
            .line(Vector2D(-0.07939088800974171, 0.45514024273004294)),
            .line(Vector2D(-0.07939088800974171, 0.2009999650412806)),
            .line(Vector2D(-0.14995485955334395, 0.18072886017094836)),
            .line(Vector2D(-0.14995485955334395, 0.07816230750855047)),
            .line(Vector2D(-0.07939088800974171, 0.0983808286381831)),
            .line(Vector2D(-0.07939088800974171, -0.14755784211476924)),
            .line(Vector2D(-0.14995485955334395, -0.16772377950370265)),
            .line(Vector2D(-0.14995485955334395, -0.2698690795951778)),
            .line(Vector2D(-0.07939088800974171, -0.24965070412687684)),
            .line(Vector2D(-0.07939088800974171, -0.5)),
            .line(Vector2D(-0.052140362172334795, -0.5)),
            .line(Vector2D(-0.052140362172334795, -0.24069966964010003)),
            .line(Vector2D(0.050498161753995435, -0.21174103163181485)),
            .line(Vector2D(0.050498161753995435, -0.4552982852748046)),
            .line(Vector2D(0.0793908880097417, -0.4552982852748046)),
            .line(Vector2D(0.0793908880097417, -0.20257951652090822)),
            .line(Vector2D(0.14995485955334395, -0.18230841165057593)),
            .line(Vector2D(0.14995485955334395, -0.07979458839020914)),
            .close
        ]
        
        return Path(commands: commands).scaled(2.25)
    }()
}
