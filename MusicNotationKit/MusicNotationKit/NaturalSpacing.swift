//
//  NaturalSpacing.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NaturalSpacing {
    
    var strength = 0.9
    
    func staveSpacing(forDuration duration: Time) -> Double {

        // Uses a curve that approximates the spacing shown in Elaine Gould's book 'Behind Bars'

        let numSemiquavers = duration.barPct * 16

        let x = numSemiquavers
        let a = Double(0).lerp(to: 1.479385, t: strength)
        let b = Double(1).lerp(to: 0.5527346, t: strength)
        let c = Double(0).lerp(to: -0.01904196, t: strength)
        let d = Double(0).lerp(to: 0.0003780756, t: strength)
        return a + b*x + (c * pow(x, 2)) + (d * pow(x, 3))
    }
}
