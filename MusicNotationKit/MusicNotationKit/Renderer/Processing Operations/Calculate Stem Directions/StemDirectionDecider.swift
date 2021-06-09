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
        let stavePositions: (N) -> [Int]
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
            let stavePosition = self.stavePosition(forNote: note)
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
    
    private func stavePosition(forNote note: N) -> Int {
        
        let stavePositions = tf.stavePositions(note)
        assert(stavePositions.count > 0, "Notes should at least have one stave position")
        
        // Single stave position
        if stavePositions.count == 1 {
            return stavePositions[0]
        }
        // Multiple stave positions - return the position that is furthest from the centre.
        // If pitches are equidistant from then the pitch above the centre line (with a
        // downwards stem) wins. If there are multiple pitches, then the majority win.
        else {
            
            var numAboveCentre = 0 // or on the centre line
            var numBelowCentre = 0
            
            var furthestAboveCentre = 0
            var furthestBelowCentre = 0
            
            for stavePosition in stavePositions {
                let isAboveCentre = stavePosition >= 0
                let distanceFromCentre = abs(stavePosition)
                if isAboveCentre {
                    numAboveCentre += 1
                    furthestAboveCentre = max(furthestAboveCentre, distanceFromCentre)
                } else {
                    numBelowCentre += 1
                    furthestBelowCentre = max(furthestBelowCentre, distanceFromCentre)
                }
            }
            
            // Resolve with the outer note
            if furthestAboveCentre > furthestBelowCentre {
                return furthestAboveCentre
            } else if furthestBelowCentre > furthestAboveCentre {
                return -furthestBelowCentre
            }
            // Else resolve with the majority of notes
            else if numAboveCentre > numBelowCentre {
                return furthestAboveCentre
            } else if numBelowCentre > numAboveCentre {
                return -furthestBelowCentre
            }
            // Else use the downwards stem note
            else {
                return furthestAboveCentre
            }
        }
    }
}

// MARK: - Notes Transformer

extension StemDirectionDecider.Transformer {
    
    static var notes: StemDirectionDecider.Transformer<Note> {
        return StemDirectionDecider.Transformer<Note>(
            stavePositions: { n in n.noteHeads.map { $0.stavePosition.location } },
            setStemDirection: { $0.stemDirection = $1 }
        )
    }
}
