//
//  HorizontalConstraintSolver.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class HorizontalConstraintSolver {
    
    func solve(_ distances: [ConstrainedDistance], layoutWidth: Double, offset: Double = 0) {
        
        if distances.minimumWidth(atPriority: .regular) <= layoutWidth {
            solveWithTiming(distances: distances, layoutWidth: layoutWidth)
        } else {
            solveWithFixedDistances(distances: distances, layoutWidth: layoutWidth)
        }
        
        // Work out the x positions
        var xPos = Double(0)
        for distance in distances {
            xPos += distance.solvedDistance
            distance.xPosition = xPos + offset
        }
        
        // Solve the distances
        distances.forEach { $0.toItem?.xPosition = $0.xPosition }
        
        // Solve sub-layouts
        var previousXPosition = Double(0)
        for distance in distances {
            if distance.leadingDistances.isEmpty == false {
                solve(distance.leadingDistances,
                      layoutWidth: distance.xPosition - previousXPosition - distance.leadingLayoutOffset - distance.trailingLayoutOffset,
                      offset: previousXPosition + distance.leadingLayoutOffset)
            }
            previousXPosition = distance.xPosition
        }
    }
    
    private func solveWithFixedDistances(distances: [ConstrainedDistance], layoutWidth: Double) {
        
        // Work out the priority that we're solving for
        var priority = ConstraintPriority.regular
        var width = distances.minimumWidth(atPriority: ConstraintPriority.regular)
        var previousPriorityWidth: Double? = nil
        var previousPriority: ConstraintPriority?
        
        for (p, isLast) in ConstraintPriority.allCasesIncreasing.enumeratedWithLastItemFlag() {
            priority = p
            width = distances.minimumWidth(atPriority: p)
            if width <= layoutWidth || isLast {
                break
            }
            previousPriorityWidth = width
            previousPriority = p
        }
        
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
    
    // MARK: - Debug
    
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
