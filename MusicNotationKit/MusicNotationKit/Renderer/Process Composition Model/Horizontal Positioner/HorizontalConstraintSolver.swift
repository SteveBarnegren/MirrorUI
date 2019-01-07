//
//  HorizontalConstraintSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol HorizontallyConstrained: class, HorizontallyPositionable {
    var duration: Time { get }
    var leadingWidth: Double { get set }
    var trailingWidth: Double { get set }
}

class HorizontalConstraintSolver {
    
    class ConstrainedDistance {
        var toItem: HorizontallyConstrained? = nil
        var requiredWidth = Double(0)
        var preferredPercent: Double?
        var solvedDistance = Double(0)
        var isSolved = false
    }
    
    func process(composition: Composition) {
        for bar in composition.bars {
            process(bar: bar)
        }
    }
    
    private func process(bar: Bar) {
        for noteSequence in bar.sequences {
            process(noteSequence: noteSequence)
        }
    }
    
    private func process(noteSequence: NoteSequence) {
        for note in noteSequence.notes {
            process(note: note)
        }
    }
    
    private func process(note: Note) {
        
        // Leading - 0.5 for the note head
        var leadingWidth = Double(0)
        leadingWidth += 0.5
        
        // Trailing - 0.5 for the note head
        var trailingWidth = Double(0)
        trailingWidth += 0.5
        
        note.leadingWidth = leadingWidth
        note.trailingWidth = trailingWidth
    }
    
    func solve(_ horizontallyConstrainedItems: [HorizontallyConstrained], layoutWidth: Double) -> [Double] {
        
        // Make distances
        let distances = makeConstrainedDistances(fromConstrainedItems: horizontallyConstrainedItems)
        
        // Solve any fixed distances
        for distance in distances {
            if distance.preferredPercent == nil {
                distance.solvedDistance = distance.requiredWidth
                distance.isSolved = true
            }
        }
        
        // Solve the remaining distances
        while distances.contains(where: { $0.isSolved == false }) {
            let unsolvedLayoutWidth = layoutWidth - distances.filter { $0.isSolved }.map { $0.solvedDistance }.sum()
            let unsolvedDistances = distances.filter { !$0.isSolved }
            let availableTime = unsolvedDistances.compactMap { $0.preferredPercent }.sum()

            if doDistancesFitTime(unsolvedDistances, availableTime: availableTime, layoutWidth: layoutWidth) {
                unsolvedDistances.forEach {
                    let percentage = $0.preferredPercent! / availableTime
                    $0.solvedDistance = unsolvedLayoutWidth * percentage
                    $0.isSolved = true
                }
            } else {
                unsolvedDistances.forEach {
                    if preferredWidth(forDistance: $0, availableTime: availableTime, layoutWidth: layoutWidth) < $0.requiredWidth {
                        $0.solvedDistance = $0.requiredWidth
                        $0.isSolved = true
                    }
                }
            }
        }

        // Work out the x positions
        var results = [Double]()
        var xPos = Double(0)
        for distance in distances where distance.toItem != nil {
            xPos += distance.solvedDistance
            results.append(xPos)
        }
        
        return results
    }

    func makeConstrainedDistances(fromConstrainedItems items: [HorizontallyConstrained]) -> [ConstrainedDistance] {
        
        var distances = [ConstrainedDistance]()
        
        var lastItem: HorizontallyConstrained?
        
        for item in items {
            let distance = ConstrainedDistance()

            if let last = lastItem {
                distance.requiredWidth += last.trailingWidth
            }
            distance.requiredWidth += item.leadingWidth
            distance.toItem = item
            distance.preferredPercent = lastItem?.duration.barPct
            distances.append(distance)
            
            lastItem = item
        }
        
        if let last = items.last {
            let distance = ConstrainedDistance()
            distance.requiredWidth +=  last.trailingWidth
            distance.preferredPercent = lastItem?.duration.barPct
            distances.append(distance)
        }
        
        return distances
    }
    
    func preferredWidth(forDistance distance: ConstrainedDistance,
                        availableTime: Double,
                        layoutWidth: Double) -> Double {
        
        guard let preferredPct = distance.preferredPercent else {
            return distance.requiredWidth
        }
        
        return layoutWidth * (preferredPct / availableTime)
    }
    
    func doDistancesFitTime(_ distances: [ConstrainedDistance], availableTime: Double, layoutWidth: Double) -> Bool {
        
        for distance in distances {
            let preferedWidth = preferredWidth(forDistance: distance, availableTime: availableTime, layoutWidth: layoutWidth)
            if preferedWidth < distance.requiredWidth {
                return false
            }
        }
        
        return true
    }
}
