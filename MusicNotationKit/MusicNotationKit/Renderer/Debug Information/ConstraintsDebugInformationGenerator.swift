//
//  ConstraintsDebugRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct ConstraintsDebugInformation {
    struct ConstraintZone {
        let color: UIColor
        let startX: Double
        let endX: Double
    }
    
    struct ItemDescription {
        let xPosition: Double
        let constraintZones: [ConstraintZone]
    }
    
    let descriptions: [ItemDescription]
}

class ConstraintsDebugInformationGenerator {
    
    func debugInformation(fromComposition composition: Composition, scale: Double) -> ConstraintsDebugInformation {
        
        var descriptions = [ConstraintsDebugInformation.ItemDescription]()
        
        for bar in composition.bars {
            
            descriptions.append(itemDescription(for: bar.leadingBarline, scale: scale))
            
            for noteSequence in bar.sequences {
                for playable in noteSequence.playables {
                    descriptions.append(itemDescription(for: playable, scale: scale))
                }
            }
        }
        
        return ConstraintsDebugInformation(descriptions: descriptions)
    }
    
    private func itemDescription(for item: HorizontallyConstrained, scale: Double) -> ConstraintsDebugInformation.ItemDescription {
        
        let xPosition = item.xPosition * scale
        var constraintZones = [ConstraintsDebugInformation.ConstraintZone]()
        
        // Leading
        var leadingX = xPosition
        for leadingConstraint in item.leadingConstraints {
            
            var maxValueLength = 0.0
            for value in leadingConstraint.values.sortedAscendingBy({ $0.priority }) {
                let zone = ConstraintsDebugInformation.ConstraintZone(color: self.color(forPriority: value.priority),
                                                                      startX: leadingX - value.length*scale,
                                                                      endX: leadingX)
                constraintZones.append(zone)
                maxValueLength = max(maxValueLength, value.length * scale)
            }
            leadingX -= maxValueLength
        }
        
        // Trailing
        var trailingX = xPosition
        for trailingConstraint in item.trailingConstraints {
            
            var maxValueLength = 0.0
            for value in trailingConstraint.values.sortedAscendingBy({ $0.priority }) {
                let zone = ConstraintsDebugInformation.ConstraintZone(color: self.color(forPriority: value.priority),
                                                                      startX: trailingX + value.length*scale,
                                                                      endX: trailingX)
                constraintZones.append(zone)
                maxValueLength = max(maxValueLength, value.length * scale)
            }
            trailingX += maxValueLength
        }
        
        let description = ConstraintsDebugInformation.ItemDescription(xPosition: item.xPosition * scale,
                                                                      constraintZones: constraintZones)
        return description
    }
    
    private func color(forPriority priority: ConstraintPriority) -> UIColor {
        switch priority {
        case .required:
            return UIColor.red.withAlphaComponent(0.5)
        case .regular:
            return UIColor.yellow.withAlphaComponent(0.5)
        }
    }
}
