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
    var barSize: BarSize
    var minimumHeight: Double
    
    func scaled(_ scale: Double) -> BarSizingInfo {
        return BarSizingInfo(barSize: barSize.scaled(scale),
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
    
    // Debugging
    var _debugConstraints = false
        
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
            
            // Configure Clefs
            ConfigureClefsProcessingOperation().process(composition: composition)
            
            // Apply tuplet timings
            ApplyTupletTimesProcessingOperation().process(composition: composition)
            
            // Join barlines
            JoinBarlinesCompositionProcessingOperation().process(composition: composition)

            // Generate time signature symbols
            GenerateTimeSignatureSymbolsProcessingOperation().process(composition: composition)
            
            // Populate note symbols
            GenerateSymbolDescriptionsProcessingOperation(glyphs: glyphs)
                .process(composition: composition)

            // Generate grace note descriptions
            GenerateGraceNoteDescriptionsProcessingOperation().process(composition: composition)

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
            GenerateBarLayoutAnchorsProcessingOperation(glyphs: glyphs)
                .process(composition: composition)
            
            // Calculate minimum bar widths
            CalculateMinimumBarWidthsProcessingOperation().process(composition: composition)
        
            composition.isPreprocessed = true
        }
        
        // Cache the minimum bar widths
        barSizingInformation = composition.barSlices.map {
            return BarSizingInfo(barSize: $0.size,
                                 minimumHeight: 10)
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
        
        // Calculate layout width
        let layoutWidth = displayWidth / staveSpacing
        
        // Get bar slices in range
        let barSlices: [BarSlice]
        let staveBars: [[Bar]]
        if let range = range {
            barSlices = composition.barSlices[range].toArray()
            staveBars = composition.staves.map { $0.bars[range].toArray() }.toArray()
        } else {
            barSlices = composition.barSlices
            staveBars = composition.staves.map { $0.bars.toArray() }.toArray()
        }
        
        // Draw just the clef at the start of the range
        barSlices.first?.isFirstBarInLine = true
        barSlices.dropFirst().forEach { $0.isFirstBarInLine = false }
        
        for barSlice in barSlices {
            for anchor in barSlice.layoutAnchors where anchor.content.visibleInFirstBarOfLineOnly {
                anchor.enabled = barSlice.isFirstBarInLine
            }
        }
        
        // Solve X Positions
        HorizontalPositionerRenderOperation().process(bars: barSlices, layoutWidth: layoutWidth)
        
        // Apply Veritical positions
        VerticalPositionerRenderOperation().process(bars: barSlices)
        
        // Calculate stem lengths
        CalculateStemLengthsRenderOperation().process(barSlices: barSlices)
        
        // Make paths - Use [bar]s from here, not slices
        var voices = [RenderableVoice]()
        for (stave, bars) in zip(composition.staves, staveBars) {    
            let leadingTies = range
                .flatMap { stave.bars[maybe: $0.startIndex-1] }
                .flatMap(trailingTies(forBar:)) ?? []
            
            let voice = RenderableVoice(bars: bars, leadingTies: leadingTies)
            voices.append(voice)
            
        }
        
        let paths = CompositionPathsCreator(glyphs: glyphs).paths(
            forVoices: voices, 
            canvasWidth: layoutWidth, 
            staveSpacing: staveSpacing
        ) 
        
        var pathBundle = PathBundle(paths: paths)
        
        // Debug information
        if _debugConstraints {
            pathBundle.debugDrawCommands += ConstraintsDebugInformationGenerator()
                .debugInformation(fromBars: barSlices,
                                  staveSpacing: staveSpacing)
        }
        
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
