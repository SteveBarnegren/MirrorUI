//
//  Clef.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

public struct Clef {
    
    enum ClefType {
        case gClef // treble
        case fClef // bass
    }
    
    var clefType: ClefType
    
    /// The pitch of the middle line of the stave
    let middleNote: Pitch.Note
}

public extension Clef {
    static let treble = Clef(clefType: .gClef, middleNote: .b4)
    static let bass = Clef(clefType: .fClef, middleNote: .d2)
}
