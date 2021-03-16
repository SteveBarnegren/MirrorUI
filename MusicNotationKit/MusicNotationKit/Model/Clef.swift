//
//  Clef.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

struct Clef {
    /// The pitch of the middle line of the stave
    let middleNote: Pitch.Note
}

extension Clef {
    static let treble = Clef(middleNote: .b4)
    static let bass = Clef(middleNote: .d2)
}
