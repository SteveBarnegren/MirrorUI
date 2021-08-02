//
//  TextArticulation.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 02/08/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class TextArticulation: ArticulationMark {
    var priorty: ArticulationMarkPriority { .text }
    var orientation: ArticulationMarkOrientation { .above }
    var stavePosition = StavePosition.zero
    var text: String

    init(text: String) {
        self.text = text
    }
}
