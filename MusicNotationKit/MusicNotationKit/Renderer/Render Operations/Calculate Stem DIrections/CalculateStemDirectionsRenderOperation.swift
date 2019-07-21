//
//  CalculateStemDirectionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 13/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemDirectionsRenderOperation: RenderOperation {
    
    private let stemDirectionDecider = StemDirectionDecider()
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.forEachBar(process)
    }
    
    private func process(bar: Bar) {
        bar.sequences.forEach(process)
    }
    
    private func process(noteSequence: NoteSequence) {
        
        noteSequence.notes
            .clustered()
            .forEach(stemDirectionDecider.process)
    }
}




// Playables

extension Array where Element: Note {
    
    func clustered() -> [[Note]] {
        return self.chunked(atChangeTo: { $0.time.convertedTruncating(toDivision: 4).value })
    }
}
