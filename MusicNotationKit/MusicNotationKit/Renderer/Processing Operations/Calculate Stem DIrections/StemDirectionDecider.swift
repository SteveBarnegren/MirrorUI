//
//  StemDirectionDecider.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/07/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class StemDirectionDecider<N> {
    
    struct Transformer<N> {
        let stavePosition: (N) -> Int
        let setStemDirection: (N, StemDirection) -> Void
    }
    
    let tf: Transformer<N>
    
    init(transformer: Transformer<N>) {
        self.tf = transformer
    }
    
    func process(noteCluster notes: [N]) {
        
        // Work out the direction for this cluster
        var numDown = 0
        var numUp = 0
        var furthestDistanceFromCenter = -1
        var furthestFromCenterDirection = StemDirection.down
        
        for note in notes {
            let stavePosition = tf.stavePosition(note)
            let distanceFromCenter = abs(stavePosition)
            let direction: StemDirection
            if stavePosition < 0 {
                numUp += 1
                direction = .up
            } else {
                numDown += 1
                direction = .down
            }
            
            if distanceFromCenter > furthestDistanceFromCenter {
                furthestDistanceFromCenter = distanceFromCenter
                furthestFromCenterDirection = direction
            } else if distanceFromCenter == furthestDistanceFromCenter && direction == .down {
                furthestFromCenterDirection = .down
            }
        }
        
        let direction: StemDirection
        if numUp > numDown {
            direction = .up
        } else if numDown > numUp {
            direction = .down
        } else {
            direction = furthestFromCenterDirection
        }
       
        // Apply stem direction to notes
        notes.forEach { tf.setStemDirection($0, direction) }
    }
}

// MARK: - Notes Transformer

extension StemDirectionDecider.Transformer {
    
    static var notes: StemDirectionDecider.Transformer<Note> {
        return StemDirectionDecider.Transformer<Note>(stavePosition: { $0.highestPitch.stavePosition },
                                                      setStemDirection: { $0.symbolDescription.stemDirection = $1 })
    }
}
