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
    var minimumHeight: Double
    
    func scaled(_ scale: Double) -> BarSizingInfo {
        return BarSizingInfo(minimumWidth: minimumWidth * scale,
                             preferredWidth: preferredWidth * scale,
                             minimumHeight: minimumHeight * scale)
    }
}

struct PathBundle {
    let paths: [Path]
    var maxY: Double { paths.map { $0.maxY }.max() ?? 0 }
    var minY: Double { paths.map { $0.minY }.min() ?? 0 }
    var height: Double { maxY - minY }
    var debugDrawCommands = [DebugDrawCommand]()
}

class MusicRenderer {
    
    private let composition: Composition
    private var barSizingInformation = [BarSizingInfo]()
    private var isPreprocessingComplete = false
    
    var staveSpacing: Double = 8
        
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
            
            // Set bar numbers
            SetBarNumbersProcessingOperation().process(composition: composition)
            
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
            
            // Calculate note head alignments
            CalculateNoteHeadAlignmentProcessingOperation().process(composition: composition)
            
            // Calculate note widths
            CalculateNoteWidthsProcessingOperation().process(composition: composition)
            
            // Create Ties
            CreateTiesProcessingOperation().process(composition: composition)
            
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
            return BarSizingInfo(minimumWidth: $0.minimumWidth, preferredWidth: $0.preferredWidth, minimumHeight: 10)
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
        // TODO: Reset the layout anchors just for the bar range?
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
        
        var pathBundle = PathBundle(paths: paths)
        
        // Debug information
        pathBundle.debugDrawCommands += ConstraintsDebugInformationGenerator().debugInformation(fromBars: bars,
                                                                                                staveSpacing: staveSpacing)
        
        return pathBundle
    }
}
