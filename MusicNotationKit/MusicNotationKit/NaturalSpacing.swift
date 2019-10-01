//
//  NaturalSpacing.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 01/10/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NaturalSpacing {
    
    func staveSpacing(forDuration duration: Time) -> Double {

        // Uses a curve that approximates the spacing shown in Elaine Gould's book 'Behind Bars'

        let numSemiquavers = duration.barPct * 16

        let x = numSemiquavers
        let a = 1.479385
        let b = 0.5527346
        let c = -0.01904196
        let d = 0.0003780756
        return a + b*x + (c * pow(x, 2)) + (d * pow(x, 3))
    }
}
