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
    
    static let zero = Time(crotchets: 0)
    
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
    
    func convertedTruncating(toDivision newDivision: Int) -> Time {
        return Time(value: self.value * newDivision/division, division: newDivision)
    }
    
    var barPct: Double {
        return 1.0 / Double(self.division) * Double(self.value)
    }
}

extension Time: Equatable {
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.division * rhs.value == rhs.division * lhs.value
    }
}

extension Time: Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.value * rhs.division < rhs.value * lhs.division
    }
}

extension Time: AdditiveArithmetic {
    
}

// Math
func +(lhs: Time, rhs: Time) -> Time {
    
    let newDivision = max(lhs.division, rhs.division)
    
    func value(forTime time: Time) -> Int {
        return time.division == newDivision ? time.value : time.value * (newDivision / time.division)
    }
    
    return Time(value: value(forTime: lhs) + value(forTime: rhs), division: newDivision)
}

func += (lhs: inout Time, rhs: Time) {
    lhs = lhs + rhs
}

func -(lhs: Time, rhs: Time) -> Time {
    
    let newDivision = max(lhs.division, rhs.division)
    
    func value(forTime time: Time) -> Int {
        return time.division == newDivision ? time.value : time.value * (newDivision / time.division)
    }
    
    return Time(value: value(forTime: lhs) - value(forTime: rhs), division: newDivision)
}

func -= (lhs: inout Time, rhs: Time) {
    lhs = lhs - rhs
}

