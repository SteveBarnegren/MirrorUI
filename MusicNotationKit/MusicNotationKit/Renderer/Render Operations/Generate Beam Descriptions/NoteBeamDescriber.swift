//
//  NoteBeamDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteBeamDescriber {
    
    func applyBeams(toNoteSequence noteSequence: NoteSequence) {
        
        let notesByBeat = noteSequence.notes.chunked(atChangeTo: { $0.time.convertedTruncating(toDivision: 4).value })
        notesByBeat.forEach { applyBeams(toNoteCluster: $0) }
    }
    
    private func applyBeams(toNoteCluster noteCluster: [Note]) {
        
        var lastNumberOfForwardConnections = 0
        
        for (index, note) in noteCluster.enumerated() {
            var beamsLeft = note.symbolDescription.numberOfBeams
            
            // forward beam connections
            var numberOfForwardBeams = 0
            if let next = noteCluster[maybe: index+1] {
                numberOfForwardBeams = min(note.symbolDescription.numberOfBeams, next.symbolDescription.numberOfBeams)
            }
            
            note.symbolDescription.beams = (0..<numberOfForwardBeams).map { NoteSymbolDescription.Beam(index: $0, style: .connectedToNext) }
            
            // Remove accounted for beams by forward or backward connections
            beamsLeft -= max(lastNumberOfForwardConnections, numberOfForwardBeams)
            
            // Add remaining beams as cut-offs
            while beamsLeft > 0 {
                let beamStyle: NoteSymbolDescription.BeamStyle = (index == noteCluster.count - 1) ? .cutOffLeft : .cutOffRight
                let beam = NoteSymbolDescription.Beam(index: note.symbolDescription.numberOfBeams - beamsLeft, style: beamStyle)
                note.symbolDescription.beams.append(beam)
                beamsLeft -= 1
            }
            
            lastNumberOfForwardConnections = note.symbolDescription.numberOfForwardBeamConnections
            
        }
    }
}
