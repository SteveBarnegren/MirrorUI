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
        // Figure out the max Y value of the content
        var maxY = 0.0

        for bar in bars {
            for sequence in bar.sequences {
                maxY = max(maxY, sequence.calculateMaxY() + 1)
            }
        }

        // Make sure that we're at least above the stave
        let staveMaxY = StavePosition(location: 6).yPosition
        maxY = maxY.constrained(min: staveMaxY)

        // Position articulations
        for bar in bars {
            bar.forEachNote { note in
                for articulationMark in note.floatingArticulationMarks {
                    articulationMark.yPosition = maxY
                }
            }
        }
    }
}

