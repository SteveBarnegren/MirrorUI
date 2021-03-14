//
//  CalculateStemLengthsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 24/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemLengthsRenderOperation {
    
    private let stemLengthCalculator = NoteClusterStemLengthCalculator(transformer: .notes)
    
    func process(barSlices: [BarSlice]) {
        for barSlice in barSlices {
            barSlice.bars.forEach(process)
        }
    }
    
    private func process(bars: [Bar]) {
        bars.forEach(process)
    }
    
    private func process(bar: Bar) {
        bar.sequences.forEach(process)
    }
    
    private func process(noteSequence: NoteSequence) {
        
        noteSequence
            .notes
            .clustered()
            .forEach(stemLengthCalculator.process)
    }
}

extension Array where Element == Note {
    
    func clustered() -> [[Note]] {
        
        var clusters = [[Note]]()
        
        var currentCluster = [Note]()
    
        func commit() {
            if currentCluster.isEmpty == false {
                clusters.append(currentCluster)
                currentCluster.removeAll()
            }
        }
        
        for note in self {
            if note.beams.isEmpty || isNoteStartOfCluster(note: note) {
                commit()
            }
            currentCluster.append(note)
        }
        
        commit()
        return clusters
    }
    
    private func isNoteStartOfCluster(note: Note) -> Bool {
        
        var foundForwardConnection = false
        
        for beam in note.beams {
            switch beam {
            case .connectedNext:
                foundForwardConnection = true
            case .connectedPrevious:
                return false
            case .connectedBoth:
                return false
            case .cutOffLeft, .cutOffRight:
                break
            }
        }
        
        return foundForwardConnection
    }
}
