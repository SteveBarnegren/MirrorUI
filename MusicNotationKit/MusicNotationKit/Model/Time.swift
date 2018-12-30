//
//  Time.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

struct Time {
    var value: Int
    var division: Int
    
    init(value: Int, division: Int) {
        self.value = value
        self.division = division
    }
    
    init(crotchets: Int) {
        self.division = 4
        self.value = crotchets
    }
    
    init(quavers: Int) {
        self.division = 8
        self.value = quavers
    }
    
    init(semiquavers: Int) {
        self.division = 16
        self.value = semiquavers
    }
}

private func makeDivisionSame(_ a: Time, _ b: Time) -> (Time, Time) {
    
    if a.division == b.division {
        return (a, b)
    }
    
    var a = a, b = b
    
    let comparisionDivision = max(a.division, b.division)
    
    if a.division != comparisionDivision {
        a.value = a.value * (comparisionDivision / a.division)
        a.division = comparisionDivision
    }
    
    if b.division != comparisionDivision {
        b.value = b.value * (comparisionDivision / b.division)
        b.division = comparisionDivision
    }
    
    return (a, b)
}

extension Time: Equatable {
    static func == (lhs: Time, rhs: Time) -> Bool {
        
        let values = makeDivisionSame(lhs, rhs)
        return values.0.value == values.1.value
    }
}

extension Time: Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        
        let values = makeDivisionSame(lhs, rhs)
        return values.0.value < values.1.value
    }
}

