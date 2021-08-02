//
//  ArticulationMark.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 26/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum ArticulationMarkOrientation {
    case above      // Above the note
    case below      // Below the note
    case byNoteHead // By the note head (above / below varies depending on stem direction)
    case byStem     // By the stem (above / below varies depending on stem direction)
}

enum ArticulationMarkPriority: Int, Comparable {
    case accent
    case text

    static func < (lhs: ArticulationMarkPriority, rhs: ArticulationMarkPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

protocol ArticulationMark: AnyObject {
    var priorty: ArticulationMarkPriority { get }
    var orientation: ArticulationMarkOrientation { get }
    var stavePosition: StavePosition { get set }
}

