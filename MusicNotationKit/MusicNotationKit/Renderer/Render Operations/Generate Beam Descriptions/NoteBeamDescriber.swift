//
//  NoteBeamDescriber.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol Beamable: class {
    var time: Time { get }
    var numberOfBeams: Int { get }
    var beams: [Beam] { get set }
}

extension Beamable {
    var numberOfForwardBeamConnections: Int {
        var num = 0
        
        for beam in beams {
            if beam.style == .connectedToNext {
                num += 1
            }
        }
        
        return num
    }
}

class NoteBeamDescriber {
    
    func applyBeams(to notes: [Beamable]) {
        
        let notesByBeat = notes.chunked(atChangeTo: { $0.time.convertedTruncating(toDivision: 4).value })
        notesByBeat.forEach { applyBeams(toNoteCluster: $0) }
    }
    
    private func applyBeams(toNoteCluster noteCluster: [Beamable]) {
        
        var lastNumberOfForwardConnections = 0
        
        for (index, item) in noteCluster.enumerated() {
            var beamsLeft = item.numberOfBeams
            
            // forward beam connections
            var numberOfForwardBeams = 0
            if let next = noteCluster[maybe: index+1] {
                numberOfForwardBeams = min(item.numberOfBeams, item.numberOfBeams)
            }
            
            item.beams = (0..<numberOfForwardBeams).map { Beam(index: $0, style: .connectedToNext) }
            
            // Remove accounted for beams by forward or backward connections
            beamsLeft -= max(lastNumberOfForwardConnections, numberOfForwardBeams)
            
            // Add remaining beams as cut-offs
            while beamsLeft > 0 {
                let beamStyle: Beam.BeamStyle = (index == noteCluster.count - 1) ? .cutOffLeft : .cutOffRight
                let beam = Beam(index: item.numberOfBeams - beamsLeft, style: beamStyle)
                item.beams.append(beam)
                beamsLeft -= 1
            }
            
            lastNumberOfForwardConnections = item.numberOfForwardBeamConnections
            
        }
    }
}
