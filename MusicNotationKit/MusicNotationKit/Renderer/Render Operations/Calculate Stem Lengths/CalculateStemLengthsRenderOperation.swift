//
//  CalculateStemLengthsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 24/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class CalculateStemLengthsRenderOperation: RenderOperation {
    
    private let stemLengthCalculator = NoteClusterStemLengthCalculator(transformer: .notes)
    
    func process(composition: Composition, layoutWidth: Double) {
        composition.bars.forEach(process)
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

extension NoteClusterStemLengthCalculator.Transformer {
    
    static var notes: NoteClusterStemLengthCalculator.Transformer<Note> {
        return NoteClusterStemLengthCalculator.Transformer<Note>(position: { $0.position },
                                                                 stemEndOffset: { $0.symbolDescription.stemEndOffset },
                                                                 stemDirection: { $0.symbolDescription.stemDirection },
                                                                 setStemLength: { note, v in note.symbolDescription.stemLength = v })
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

