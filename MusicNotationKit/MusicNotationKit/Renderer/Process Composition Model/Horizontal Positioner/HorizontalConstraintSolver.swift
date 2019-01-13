//
//  HorizontalConstraintSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class ConstrainedDistance {
    var toItem: HorizontallyConstrained? = nil
    var constraints = [HorizontalConstraint]()
    var preferredPercent: Double?
    var solvedDistance = Double(0)
    var xPosition = Double(0)
    var isSolved = false
    
    func minimumDistance(atPriority priority: ConstraintPriority) -> Double {
        return constraints.map { $0.minimumDistance(atPriority: priority) }.sum()
    }
}

class HorizontalConstraintSolver {
    
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
        
        print("*************************")
        
        // Make distances
        let distances = makeConstrainedDistances(fromConstrainedItems: horizontallyConstrainedItems)
        
        print("Minimum width = \(minimumWidth(forDistances: distances, atPriority: .regular))")
        print("Layout width = \(layoutWidth)")
        if minimumWidth(forDistances: distances, atPriority: .regular) <= layoutWidth {
            print("Solve with timing")
            solveWithTiming(distances: distances, layoutWidth: layoutWidth)
        } else {
            print("Solve with minimum distance")
            solveWithMinimumDistances(distances: distances, layoutWidth: layoutWidth)
        }
        
        // Work out the x positions
        var xPos = Double(0)
        for distance in distances {
            xPos += distance.solvedDistance
            distance.xPosition = xPos
        }
        
        //debug_printDistances(distances)
        //debug_printDistancePositions(distances)
        
        return distances.filter { $0.toItem != nil }.map { $0.xPosition }
    }
    
    private func solveWithMinimumDistances(distances: [ConstrainedDistance], layoutWidth: Double) {
        
        // Work out the priority that we're solving for
        var priority = ConstraintPriority.regular
        var width = minimumWidth(forDistances: distances, atPriority: ConstraintPriority.regular)
        var previousPriorityWidth: Double? = nil
        var previousPriority: ConstraintPriority?
        
        for (p, isLast) in ConstraintPriority.allCasesIncreasing.enumeratedWithLastItemFlag() {
            priority = p
            width = minimumWidth(forDistances: distances, atPriority: p)
            if width <= layoutWidth || isLast {
                break
            }
            previousPriorityWidth = width
            previousPriority = p
        }
        print("priority: \(priority)")
        
        // TODO: We need to be able to layout with values between 2 priorities
        for distance in distances {
            if let previousPriority = previousPriority, let previousPriorityWidth = previousPriorityWidth {
                let ratio = layoutWidth.pct(between: width, and: previousPriorityWidth).constrained(min: 0, max: 1)
                let previousDist = distance.minimumDistance(atPriority: previousPriority)
                let dist = distance.minimumDistance(atPriority: priority)
                distance.solvedDistance = dist.interpolate(to: previousDist, t: ratio)
                
            } else {
                distance.solvedDistance = distance.minimumDistance(atPriority: priority)
            }
            
            distance.isSolved = true
        }
    }
    
    private func solveWithTiming(distances: [ConstrainedDistance], layoutWidth: Double) {
        
        // Solve any fixed distances
        for distance in distances {
            if distance.preferredPercent == nil {
                distance.solvedDistance = distance.minimumDistance(atPriority: .regular)
                distance.isSolved = true
            }
        }
        
        // Solve the remaining distances
        while distances.contains(where: { $0.isSolved == false }) {
            let unsolvedLayoutWidth = layoutWidth - distances.filter { $0.isSolved }.map { $0.solvedDistance }.sum()
            let unsolvedDistances = distances.filter { !$0.isSolved }
            let availableTime = unsolvedDistances.compactMap { $0.preferredPercent }.sum()
            
            if doDistancesFitTime(unsolvedDistances, availableTime: availableTime, availableWidth: unsolvedLayoutWidth, priority: .regular) {
                unsolvedDistances.forEach {
                    let percentage = $0.preferredPercent! / availableTime
                    $0.solvedDistance = unsolvedLayoutWidth * percentage
                    $0.isSolved = true
                }
            } else {
                unsolvedDistances.forEach {
                    let minimumDistance = $0.minimumDistance(atPriority: .regular)
                    if preferredWidth(forDistance: $0, availableTime: availableTime, availableWidth: unsolvedLayoutWidth, priority: .regular) < minimumDistance {
                        $0.solvedDistance = minimumDistance
                        $0.isSolved = true
                    }
                }
            }
        }
        
        // Work out the x positions
        var xPos = Double(0)
        for distance in distances {
            xPos += distance.solvedDistance
            distance.xPosition = xPos
        }
    }
    
    private func minimumWidth(forDistances distances: [ConstrainedDistance], atPriority priority: ConstraintPriority) -> Double {
        return distances.map { $0.minimumDistance(atPriority: priority) }.sum()
    }
    
    /*
     func solve(_ horizontallyConstrainedItems: [HorizontallyConstrained], layoutWidth: Double) -> [Double] {
     
     // Make distances
     let distances = makeConstrainedDistances(fromConstrainedItems: horizontallyConstrainedItems)
     
     dump(distances)
     
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
     
     if doDistancesFitTime(unsolvedDistances, availableTime: availableTime, availableWidth: unsolvedLayoutWidth) {
     unsolvedDistances.forEach {
     let percentage = $0.preferredPercent! / availableTime
     $0.solvedDistance = unsolvedLayoutWidth * percentage
     $0.isSolved = true
     }
     } else {
     unsolvedDistances.forEach {
     if preferredWidth(forDistance: $0, availableTime: availableTime, availableWidth: unsolvedLayoutWidth) < $0.requiredWidth {
     $0.solvedDistance = $0.requiredWidth
     $0.isSolved = true
     }
     }
     }
     }
     
     // Work out the x positions
     var xPos = Double(0)
     for distance in distances {
     xPos += distance.solvedDistance
     distance.xPosition = xPos
     }
     
     debug_printDistances(distances)
     debug_printDistancePositions(distances)
     
     return distances.filter { $0.toItem != nil }.map { $0.xPosition }
     }
 
 */
    
    func makeConstrainedDistances(fromConstrainedItems items: [HorizontallyConstrained]) -> [ConstrainedDistance] {
        
        var distances = [ConstrainedDistance]()
        
        var lastItem: HorizontallyConstrained?
        
        for item in items {
            let distance = ConstrainedDistance()
            
            if let last = lastItem {
                distance.constraints += last.trailingConstraints
            }
            distance.constraints += item.leadingConstraints
            distance.toItem = item
            distance.preferredPercent = lastItem?.layoutDuration?.barPct
            distances.append(distance)
            
            lastItem = item
        }
        
        if let last = items.last {
            let distance = ConstrainedDistance()
            distance.constraints +=  last.trailingConstraints
            distance.preferredPercent = lastItem?.layoutDuration?.barPct
            distances.append(distance)
        }
        
        return distances
    }
    
    func preferredWidth(forDistance distance: ConstrainedDistance,
                        availableTime: Double,
                        availableWidth: Double,
                        priority: ConstraintPriority) -> Double {
        
        guard let preferredPct = distance.preferredPercent else {
            return distance.minimumDistance(atPriority: priority)
        }
        
        return availableWidth * (preferredPct / availableTime)
    }
    
    func doDistancesFitTime(_ distances: [ConstrainedDistance], availableTime: Double, availableWidth: Double, priority: ConstraintPriority) -> Bool {
        
        for distance in distances {
            let preferedWidth = preferredWidth(forDistance: distance, availableTime: availableTime, availableWidth: availableWidth, priority: priority)
            if preferedWidth < distance.minimumDistance(atPriority: priority) {
                return false
            }
        }
        
        return true
    }
    
    func debug_printDistances(_ distances: [ConstrainedDistance]) {
        
        print("**** DISTANCE solved distances ****")
        for distance in distances {
            var string = ""
            if distance.toItem is Barline {
                string += "Barline: "
            } else if distance.toItem is Note {
                string += "Note: "
            } else {
                string += "Unknown: "
            }
            
            print(string + "\(distance.solvedDistance)")
        }
    }
    
    func debug_printDistancePositions(_ distances: [ConstrainedDistance]) {
        
        print("**** DISTANCE positions ****")
        for distance in distances {
            var string = ""
            if distance.toItem is Barline {
                string += "Barline: "
            } else if distance.toItem is Note {
                string += "Note: "
            } else {
                string += "Unknown: "
            }
            
            print(string + "\(distance.xPosition)")
        }
        
    }
}
