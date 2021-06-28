//
//  TextArticulation.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 17/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class TextArticulation: ArticulationMark {
    var text: String

    // ArticulationMark
    var stavePosition = StavePosition.zero

    init(text: String) {
        self.text = text
    }
}
