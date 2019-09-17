//
//  MusicRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

typealias DisplaySize = Vector2<Double>

class MusicRenderer {
    
    let composition: Composition
    let staveSpacing: Double = 8
    
    var _generateConstraintsDebugInformation = false
    var _constraintsDebugInformation: ConstraintsDebugInformation?
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func paths(forDisplaySize displaySize: DisplaySize) -> [Path] {
        
        // Calculate layout sizes
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        let layoutWidth = displaySize.width / staveSpacing
        print("Layout width: \(layoutWidth)")
    
        // Populate note symbols
        GenerateSymbolDescriptionsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Calculate note times
        CalculatePlayableItemTimesRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Populate note beams
        GenerateBeamDescriptionsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Calculate stem directions
        CalculateStemDirectionsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Solve X Positions
        HorizontalPositionerRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositionerRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Calculate stem lengths
        CalculateStemLengthsRenderOperation().process(composition: composition, layoutWidth: layoutWidth)
        
        // Make paths
        let paths = CompositionPathsCreator().paths(fromComposition: composition,
                                                    canvasSize: canvasSize,
                                                    staveSpacing: staveSpacing,
                                                    displaySize: displaySize)
     
        // Generate debug information
        if _generateConstraintsDebugInformation {
            _constraintsDebugInformation = ConstraintsDebugInformationGenerator().debugInformation(fromComposition: composition, scale: staveSpacing)
        }
        
        return paths
    }
}
