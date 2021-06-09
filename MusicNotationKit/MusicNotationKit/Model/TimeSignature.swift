//
//  TimeSignature.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 27/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public struct TimeSignature: Equatable {
    
    enum Style {
        case straight
        case triplet
    }

    var value: Int
    var division: Int
    
    var style: Style {
        switch (self.value, self.division) {
        case (4, 4):
            return .straight
        case (6, 8):
            return .triplet
        case (12, 8):
            return .triplet
        default:
            fatalError("Unsupported time signature: \(self)")
        }
    }
    
    var barDuration: Time {
        return Time(value: value, division: division)
    }
    
    var beatDuration: Time {
        return Time(value: 1, division: division)
    }
    
    var groupingDuration: Time {
        switch self.style {
        case .straight:
            return self.beatDuration
        case .triplet:
            return self.beatDuration * 3
        }
    }
    
    init(value: Int, division: Int) {
        
        guard division == 4 || division == 8 || division == 16 || division == 2 else {
            fatalError("Invalid time signature division: \(division)")
        }
        
        self.value = value
        self.division = division
    }
    
    init(_ value: Int, _ division: Int) {
        self.init(value: value, division: division)
    }
    
    func allowsExtendedBeaming(forDuration duration: Time) -> Bool {
    
        switch duration {
        case Time(quavers: 1):
            return self == .fourFour || self == .sixEight
        case Time(semiquavers: 1):
            return self == .sixEight
        default:
            return false
        }
    }

    /// The bar times at which beams must not cross
    func beamBreaks() -> AnySequence<Time> {
        
        func every(_ time: Time) -> AnySequence<Time> {
            return IncrementingSequence(initialValue: time, incrementer: {
                return $0 + time
            }).toAnySequence()
        }
        
        func every(values: [Int], division: Int) -> AnySequence<Time> {
            let times = values.map { Time(value: $0, division: division) }
            return IncrementingSequence(repeatingAdditive: times).toAnySequence()
        }
        
        // 4/16
        if self == TimeSignature(value: 4, division: 16) {
            return every(Time(semiquavers: 2))
        }
        // 5/16
        else if self == TimeSignature(value: 5, division: 16) {
            return every(values: [3, 2], division: 16)
        }
        // 6/16
        else if self == TimeSignature(value: 6, division: 16) {
            return every(Time(semiquavers: 3))
        }
        // 8/16
        else if self == TimeSignature(value: 8, division: 16) {
            return every(Time(semiquavers: 4))
        }
        // 4/8
        else if self == TimeSignature(value: 4, division: 8) {
            return every(Time(quavers: 2))
        }
        // 9/16
        else if self == TimeSignature(value: 9, division: 16) {
            return every(Time(semiquavers: 3))
        }
        // 5/8
        else if self == TimeSignature(value: 5, division: 8) {
            return every(values: [3, 2], division: 8)
        }
        // 12/16
        else if self == TimeSignature(value: 12, division: 16) {
            return every(Time(semiquavers: 3))
        }
        // 6/8
        else if self == TimeSignature(value: 6, division: 8) {
            return every(Time(quavers: 3))
        }
        // 7/8
        else if self == TimeSignature(value: 7, division: 8) {
            return every(values: [4, 3], division: 8)
        }
        // 8/8
        else if self == TimeSignature(value: 8, division: 8) {
            return every(values: [3, 3, 2], division: 8)
        }
        // 4/4
        else if self == TimeSignature(value: 4, division: 4) {
            return every(Time(crotchets: 2))
        }
        // 2/2
        else if self == TimeSignature(value: 2, division: 2) {
            return every(Time(crotchets: 2))
        }
        // 9/8
        else if self == TimeSignature(value: 9, division: 8) {
            return every(Time(quavers: 3))
        }
        // 10/8
        else if self == TimeSignature(value: 10, division: 8) {
            return every(values: [4, 3, 3], division: 8)
        }
        // 5/4
        else if self == TimeSignature(value: 5, division: 4) {
            return every(values: [3, 2], division: 4)
        }
        // 12/8
        else if self == TimeSignature(value: 12, division: 8) {
            return every(Time(quavers: 3))
        }
        // 6/4
        else if self == TimeSignature(value: 6, division: 4) {
            return every(Time(crotchets: 3))
        }
        // 3/2
        else if self == TimeSignature(value: 3, division: 2) {
            return every(Time(crotchets: 2))
        }
        // 7/4
        else if self == TimeSignature(value: 7, division: 4) {
            return every(values: [4, 3], division: 4)
        }
        // 15/8
        else if self == TimeSignature(value: 15, division: 8) {
            return every(Time(quavers: 3))
        }
        // 18/8
        else if self == TimeSignature(value: 18, division: 8) {
            return every(Time(quavers: 3))
        }
        // 9/4
        else if self == TimeSignature(value: 9, division: 4) {
            return every(Time(crotchets: 3))
        } else {
            return AnySequence([])
        }
    }
}

extension TimeSignature {
    public static let fourFour = TimeSignature(value: 4, division: 4)
    public static let sixEight = TimeSignature(value: 6, division: 8)
    public static let twelveEight = TimeSignature(value: 12, division: 8)
}
