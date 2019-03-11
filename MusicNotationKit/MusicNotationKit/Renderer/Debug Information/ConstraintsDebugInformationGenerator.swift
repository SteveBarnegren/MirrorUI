//
//  ConstraintsDebugRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

struct ConstraintsDebugInformation {
    struct ItemDescription {
        let xPosition: Double
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
        let description = ConstraintsDebugInformation.ItemDescription(xPosition: item.xPosition * scale)
        item.leadingConstraints
        return description
    }
}
