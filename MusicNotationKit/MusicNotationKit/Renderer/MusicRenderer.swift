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
    private var glyphs: GlyphStore!
    
    var staveSpacing: Double = 8
        
    init(composition: Composition) {
        FontLoader.loadFonts()
        glyphs = GlyphStore(font: .bravura)

        self.composition = composition
    }
    
    func preprocessComposition() {
        
        if isPreprocessingComplete {
            return
        }
        
        if !composition.isPreprocessed {
            
            // Add final barline (this should definitely be done somewhere else)
            for stave in composition.staves {
                stave.bars.last?.trailingBarline = Barline()
            }
            
            // Set bar numbers
            SetBarNumbersProcessingOperation().process(composition: composition)
            
            // Apply tuplet timings
            ApplyTupletTimesProcessingOperation().process(composition: composition)
            
            // Join barlines
            JoinBarlinesCompositionProcessingOperation().process(composition: composition)
            
            // Populate note symbols
            GenerateSymbolDescriptionsProcessingOperation(glyphs: glyphs)
                .process(composition: composition)

            // Calculate note times
            CalculatePlayableItemTimesProcessingOperation().process(composition: composition)
            
            // Populate note beams
            GenerateBeamDescriptionsProcessingOperation().process(composition: composition)
            
            // Calculate stem directions
            CalculateStemDirectionsProcessingOperation().process(composition: composition)
            
            // Calculate Stem Positons
            CalculateStemPositionsProcessingOperation(glyphs: glyphs)
                .process(composition: composition)
            
            // Calculate note head alignments
            CalculateNoteHeadAlignmentProcessingOperation().process(composition: composition)
            
            // Calculate playable item widths
            CalculatePlayableItemWidthsProcessingOperation(glyphs: glyphs)
                .process(composition: composition)
            
            // Position Articulation marks
            PositionArticulationMarksProcessingOperation().process(composition: composition)
            
            // Create Ties
            CreateTiesProcessingOperation().process(composition: composition)
            
            // Create bar slices
            CreateBarSlicesRenderOperation().process(composition: composition)
            
            // Generate bar layout anchors
            GenerateBarLayoutAnchorsProcessingOperation().process(composition: composition)
            
            // Calculate minimum bar widths
            CalculateMinimumBarWidthsProcessingOperation().process(composition: composition)
            
            // Stitch bar layout anchors
            // StitchBarLayoutAnchorsProcessingOperation().process(composition: composition)
        
            composition.isPreprocessed = true
        }
        
        // Cache the minimum bar widths
        barSizingInformation = composition.barSlices.map {
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
        
        let barSlices: [BarSlice]
        let staveBars: [[Bar]]
        if let range = range {
            barSlices = composition.barSlices[range].toArray()
            staveBars = composition.staves.map { $0.bars[range].toArray() }.toArray()
        } else {
            barSlices = composition.barSlices
            staveBars = composition.staves.map { $0.bars.toArray() }.toArray()
        }
        
        // Reset layout anchors
        // TODO: Reset the layout anchors just for the bar range?
        composition.barSlices.forEach { $0.resetLayoutAnchors() }
        
        // Solve X Positions
        HorizontalPositionerRenderOperation().process(bars: barSlices, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositionerRenderOperation().process(bars: barSlices)
        
        // Calculate stem lengths
        CalculateStemLengthsRenderOperation().process(barSlices: barSlices)
        
        // Make paths - Use bars from here, not slices
        var voices = [RenderableVoice]()
        for (stave, bars) in zip(composition.staves, staveBars) {    
            let leadingTies = range
                .flatMap { stave.bars[maybe: $0.startIndex-1] }
                .flatMap(trailingTies(forBar:)) ?? []
            
            let voice = RenderableVoice(bars: bars, leadingTies: leadingTies)
            voices.append(voice)
            
        }
        
        let paths = CompositionPathsCreator(glyphs: glyphs).paths(forVoices: voices, 
                                                                  canvasWidth: layoutWidth, 
                                                                  staveSpacing: staveSpacing) 
        
//        let paths = CompositionPathsCreator(glyphs: glyphs).paths(fromBars: bars,
//                                                                  canvasWidth: layoutWidth,
//                                                                  staveSpacing: staveSpacing,
//                                                                  leadingTies: leadingTies)
        
        var pathBundle = PathBundle(paths: paths)
        
        // Debug information
        /*
        pathBundle.debugDrawCommands += ConstraintsDebugInformationGenerator().debugInformation(fromBars: bars,
                                                                                                staveSpacing: staveSpacing)
        */
        return pathBundle
    }
    
    private func trailingTies(forBar bar: Bar) -> [Tie] {
        
        var ties = [Tie]()
        
        for sequence in bar.sequences {
            for note in sequence.notes {
                for noteHead in note.noteHeads {
                    if let tie = noteHead.tie?.chosenVariation, tie.endNoteCompositionTime.bar != bar.barNumber {
                        ties.append(maybe: noteHead.tie?.chosenVariation)
                    }
                }
            }
        }
        
        return ties
    }
}
