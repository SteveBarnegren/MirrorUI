//
//  NoteValue.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public enum NoteValue {
    case whole
    case half
    case quarter
    case eighth
    case sixteenth
    
    var duration: Time {
        switch self {
        case .whole: return Time(crotchets: 4)
        case .half: return Time(crotchets: 2)
        case .quarter: return Time(crotchets: 1)
        case .eighth: return Time(quavers: 1)
        case .sixteenth: return Time(semiquavers: 1)
        }
    }
}
