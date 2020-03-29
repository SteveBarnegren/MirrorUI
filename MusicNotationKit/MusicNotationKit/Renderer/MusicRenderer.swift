//
//  MusicRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

typealias DisplaySize = Vector2<Double>

struct BarSizingInfo {
    var minimumWidth: Double
    var preferredWidth: Double
    var height: Double
    
    func scaled(_ scale: Double) -> BarSizingInfo {
        return BarSizingInfo(minimumWidth: minimumWidth * scale,
                             preferredWidth: preferredWidth * scale,
                             height: height * scale)
    }
}

struct PathBundle {
    let paths: [Path]
    var maxY: Double { paths.map { var copy = $0; return copy.maxY() }.max() ?? 0 }
    var minY: Double { paths.map { var copy = $0; return copy.minY() }.min() ?? 0 }
    var height: Double { maxY - minY }
}

class MusicRenderer {
    
    private let composition: Composition
    private var barSizingInformation = [BarSizingInfo]()
    private var isPreprocessingComplete = false
    
    var staveSpacing: Double = 8
    
    var _generateConstraintsDebugInformation = false
    var _constraintsDebugInformation: ConstraintsDebugInformation?
    
    init(composition: Composition) {
        self.composition = composition
    }
    
    func preprocessComposition() {
        
        if isPreprocessingComplete {
            return
        }
        
        if !composition.isPreprocessed {
            
            // Add final barline (this should definitely be done somewhere else)
            composition.bars.last?.trailingBarline = Barline()
            
            // Join barlines
            JoinBarlinesCompositionProcessingOperation().process(composition: composition)
            
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
            //StitchBarLayoutAnchorsProcessingOperation().process(composition: composition)
        
            composition.isPreprocessed = true
        }
        
        // Cache the minimum bar widths
        barSizingInformation = composition.bars.map {
            return BarSizingInfo(minimumWidth: $0.minimumWidth, preferredWidth: $0.preferredWidth, height: 12)
        }
        
        isPreprocessingComplete = true
    }
    
    func barSizes() -> [BarSizingInfo] {
        return barSizingInformation.map { $0.scaled(staveSpacing) }
    }
    
    func pathBundle(forDisplayWidth displayWidth: Double, range: Range<Int>? = nil) -> PathBundle {
        
        if !isPreprocessingComplete {
            fatalError("Must preprocess composition first")
        }
        
        // Calculate layout sizes
        let layoutWidth = displayWidth / staveSpacing
        
        let bars: [Bar]
        if let range = range {
            bars = composition.bars[range].toArray()
        } else {
            bars = composition.bars
        }
        
        // Reset layout anchors
        composition.bars.forEach { $0.resetLayoutAnchors() }
        
        // Solve X Positions
        HorizontalPositionerRenderOperation().process(bars: bars, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositionerRenderOperation().process(bars: bars)
        
        // Calculate stem lengths
        CalculateStemLengthsRenderOperation().process(bars: bars)
        
        // Make paths
        let paths = CompositionPathsCreator().paths(fromBars: bars,
                                                    canvasWidth: layoutWidth,
                                                    staveSpacing: staveSpacing)

        // Generate debug information
        if _generateConstraintsDebugInformation {
            _constraintsDebugInformation = ConstraintsDebugInformationGenerator().debugInformation(fromComposition: composition, scale: staveSpacing)
        }

        let pathBundle = PathBundle(paths: paths)
        return pathBundle
    }
}
