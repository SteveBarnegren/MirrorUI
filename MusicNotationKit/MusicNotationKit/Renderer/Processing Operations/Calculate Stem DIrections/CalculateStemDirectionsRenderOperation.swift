//
//  CalculateStemDirectionsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 13/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemDirectionsProcessingOperation: CompositionProcessingOperation {
    
    private let stemDirectionDecider = StemDirectionDecider(transformer: .notes)
    
    func process(composition: Composition) {
        composition.forEachBar(process)
    }
    
    private func process(bar: Bar) {
        process(noteSequences: bar.sequences)
    }
    
    private func process(noteSequences: [NoteSequence]) {
        
        if noteSequences.count <= 1 {
            for sequence in noteSequences {
                sequence.notes
                    .clustered()
                    .forEach(stemDirectionDecider.process)
            }
            return
        }
        
        let averagePitches = noteSequences.map(averagePitch)
        
        for (sequence, pitch) in zip(noteSequences, averagePitches) {
            if averagePitches.contains(where: { $0 > pitch }) {
                sequence.notes.forEach { $0.symbolDescription.stemDirection = .down }
            } else {
                sequence.notes.forEach { $0.symbolDescription.stemDirection = .up }
            }
        }
    }
    
    private func averagePitch(forNoteSequence noteSequence: NoteSequence) -> Int {
        return noteSequence.notes.sum { $0.highestPitch.rawValue }
    }
}
