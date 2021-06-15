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
        case (6, 8), (9, 8), (12, 8):
            return .triplet
        default:
            return .straight
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

        switch (value, division) {

            case (2,2):
                return every(Time(crotchets: 2))
            case (3,2):
                return every(Time(crotchets: 2))
            case (4,4):
                return every(Time(crotchets: 2))
            case (5,4):
                return every(values: [3, 2], division: 4)
            case (6,4):
                return every(Time(crotchets: 3))
            case (7,4):
                return every(values: [4, 3], division: 4)
            case (9,4):
                return every(Time(crotchets: 3))
            case (4,8):
                return every(Time(quavers: 2))
            case (5,8):
                return every(values: [3, 2], division: 8)
            case (6,8):
                return every(Time(quavers: 3))
            case (7,8):
                return every(values: [4, 3], division: 8)
            case (8,8):
                return every(values: [3, 3, 2], division: 8)
            case (9,8):
                return every(Time(quavers: 3))
            case (10,8):
                return every(values: [4, 3, 3], division: 8)
            case (12,8):
                return every(Time(quavers: 3))
            case (15,8):
                return every(Time(quavers: 3))
            case (18,8):
                return every(Time(quavers: 3))
            case (4, 16):
                return every(Time(semiquavers: 2))
            case (5,16):
                return every(values: [3, 2], division: 16)
            case (6,16):
                return every(Time(semiquavers: 3))
            case (8,16):
                return every(Time(semiquavers: 4))
            case (9,16):
                return every(Time(semiquavers: 3))
            case (12,16):
                return every(Time(semiquavers: 3))
            default:
                return AnySequence([])
        }
    }
}

extension TimeSignature {

    // Quarter
    public static let twoFour = TimeSignature(value: 2, division: 4)
    public static let threeFour = TimeSignature(value: 3, division: 4)
    public static let fourFour = TimeSignature(value: 4, division: 4)
    public static let fiveFour = TimeSignature(value: 5, division: 4)
    public static let sixFour = TimeSignature(value: 6, division: 4)
    public static let sevenFour = TimeSignature(value: 7, division: 4)

    // Eighth
    public static let fiveEight = TimeSignature(value: 5, division: 8)
    public static let sixEight = TimeSignature(value: 6, division: 8)
    public static let sevenEight = TimeSignature(value: 7, division: 8)
    public static let nineEight = TimeSignature(value: 9, division: 8)
    public static let elevenEight = TimeSignature(value: 11, division: 8)
    public static let twelveEight = TimeSignature(value: 12, division: 8)
}
