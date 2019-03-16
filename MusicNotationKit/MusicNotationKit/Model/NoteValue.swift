//
//  NoteValue.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public struct NoteValue {
    
    public static let whole = NoteValue(division: 1)
    public static let half = NoteValue(division: 2)
    public static let quarter = NoteValue(division: 4)
    public static let eighth = NoteValue(division: 8)
    public static let sixteenth = NoteValue(division: 16)
    
    var division: Int
    
    public init(division: Int) {
        self.division = division
    }
    
    var duration: Time {
        return Time(value: 1, division: division)
    }
}

//public enum NoteValue {
//    case whole
//    case half
//    case quarter
//    case eighth
//    case sixteenth
//    case division(Int)
//
//    var duration: Time {
//        switch self {
//        case .whole: return Time(crotchets: 4)
//        case .half: return Time(crotchets: 2)
//        case .quarter: return Time(crotchets: 1)
//        case .eighth: return Time(quavers: 1)
//        case .sixteenth: return Time(semiquavers: 1)
//        case .division(let division):
//
//
//
//            return Time(value: 1, division: division)
//        }
//    }
//}
