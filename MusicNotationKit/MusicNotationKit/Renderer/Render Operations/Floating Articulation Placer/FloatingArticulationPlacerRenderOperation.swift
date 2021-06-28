//
//  FloatingArticulationPlacerRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 17/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class FloatingArticulationPlacerRenderOperation {

    func process(bars: [Bar]) {
        // TODO: This is temporary! Need to be able to figure out the stave position from notes.
        var maxY = 0.0

        for bar in bars {
            for sequence in bar.sequences {
                maxY = max(maxY, sequence.calculateMaxY())
            }
        }

        for bar in bars {
            bar.forEachNote { note in
                for articulationMark in note.floatingArticulationMarks {
                    articulationMark.stavePosition = StavePosition(location: 6)
                }
            }
        }
    }
}

