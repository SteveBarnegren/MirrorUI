//
//  CalculateStemLengthsRenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 24/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

private let preferredStemLength = 3.5 // One octave

class CalculateStemLengthsRenderOperation: RenderOperation {
    
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
            .forEach(process)
    }
    
    private func process(noteCluster: [Note]) {
        
        if noteCluster.count <= 1 {
            noteCluster.forEach { $0.symbolDescription.stemLength = preferredStemLength }
            return
        }

        // First and last notes should be the preferred length
        let firstNote = noteCluster.first!
        let lastNote = noteCluster.last!
        [firstNote, lastNote].forEach { $0.symbolDescription.stemLength = preferredStemLength }
        
        // Middle notes should be between first and last values
        let firstY = firstNote.position.y + firstNote.symbolDescription.stemEndOffset
        let lastY = lastNote.position.y + lastNote.symbolDescription.stemEndOffset
        
        for note in noteCluster.dropFirst().dropLast() {
            let xPct = (note.position.x - firstNote.position.x) / (lastNote.position.x - firstNote.position.x)
            let stemEnd = firstY + (lastY-firstY)*xPct
            note.symbolDescription.stemLength = (stemEnd - note.position.y).inverted(if: { note.symbolDescription.stemDirection == .down })
        }
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

