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
    
    private let composition: Composition
    private var _minimumBarWidths = [Double]()
    private var isPreprocessingComplete = false
    
    let staveSpacing: Double = 8
    
    var _generateConstraintsDebugInformation = false
    var _constraintsDebugInformation: ConstraintsDebugInformation?
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func preprocessComposition() {
        
        if isPreprocessingComplete {
            return
        }
        
        // Add final barine (this should definitely be done somewhere else)
        composition.bars.last?.trailingBarline = Barline()
        
        // Populate note symbols
        GenerateSymbolDescriptionsProcessingOperation().process(composition: composition)
        
        // Calculate note times
        CalculatePlayableItemTimesProcessingOperation().process(composition: composition)
        
        // Populate note beams
        GenerateBeamDescriptionsProcessingOperation().process(composition: composition)
        
        // Calculate stem directions
        CalculateStemDirectionsProcessingOperation().process(composition: composition)
        
        // Generate bar layout anchors
        GenerateBarLayoutAnchorsProcessingOperation().process(composition: composition)
        
        // Calculate minimum bar widths
        CalculateMinimumBarWidthsProcessingOperation().process(composition: composition)
        
        // Stitch bar layout anchors
        StitchBarLayoutAnchorsProcessingOperation().process(composition: composition)
        
        // Cache the minimum bar widths
        _minimumBarWidths = composition.bars.map { $0.minimumWidth }
        
        isPreprocessingComplete = true
    }
    
    func minimumBarWidths() -> [Double] {
        return _minimumBarWidths.map { $0 * staveSpacing }
    }
    
    func paths(forDisplaySize displaySize: DisplaySize, range: Range<Int>? = nil) -> [Path] {
        
        if !isPreprocessingComplete {
            fatalError("Must preprocess composition first")
        }
        
        // Calculate layout sizes
        let canvasSize = Size(width: displaySize.width / staveSpacing, height: displaySize.height / staveSpacing)
        let layoutWidth = displaySize.width / staveSpacing
        print("Layout width: \(layoutWidth)")
    
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
