//
//  NoteHeadAligner.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteHeadAligner {
    
    static func xOffset(forAlignment alignment: NoteHeadAlignment) -> Double {
        
        switch alignment {
        case .center:
            return 0
        case .leftOfStem:
            return -(1 + NoteMetrics.stemThickness)
        case .rightOfStem:
            return 1 + NoteMetrics.stemThickness
        }
    }
}
