import Foundation

private let staveSeparation = 0.8

struct RenderableVoice {
    var staveStyle: StaveStyle
    var bars: [Bar]
    var leadingTies: [Tie]
}

class CompositionPathsCreator {

    private let metrics: FontMetrics
    private let glyphRenderer: GlyphRenderer
    private let noteRenderer: NoteRenderer
    private let tieRenderer: TieRenderer
    private let tupletMarksRenderer: TupletMarksRenderer
    private let graceNoteRenderer: GraceNoteRenderer
    private let timeSignatureRenderer: TimeSignatureRenderer
    private let barlineRenderer: BarlineRenderer
    
    init(glyphs: GlyphStore) {
        self.metrics = glyphs.metrics
        self.glyphRenderer = GlyphRenderer(glyphStore: glyphs)
        self.noteRenderer = NoteRenderer(glyphs: glyphs)
        self.tieRenderer = TieRenderer(glyphs: glyphs)
        self.tupletMarksRenderer = TupletMarksRenderer(glyphs: glyphs)
        self.graceNoteRenderer = GraceNoteRenderer(glyphs: glyphs)
        self.timeSignatureRenderer = TimeSignatureRenderer(glyphs: glyphs)
        self.barlineRenderer = BarlineRenderer(glyphs: glyphs)
    }
    
    func paths(forVoices voices: [RenderableVoice], canvasWidth: Double, staveSpacing: Double) -> [Path] {
        
        var yOffset = 0.0
        var allPaths = [Path]()
        for (index, voice) in voices.enumerated() {
            
            var paths = self.paths(fromBars: voice.bars,
                                   canvasWidth: canvasWidth, 
                                   leadingTies: voice.leadingTies,
                                   staveStyle: voice.staveStyle)
            
            if index != 0 {
                yOffset += abs(paths.minY)
            }
            
            if yOffset != 0 {
                paths = paths.map { $0.translated(x: 0, y: yOffset)  }
            }
            allPaths += paths
            yOffset += abs(paths.maxY)
            yOffset += staveSeparation
        }
        
        return allPaths.map { $0.scaled(staveSpacing) }
    }
    
    func paths(fromBars bars: [Bar], canvasWidth: Double, leadingTies: [Tie], staveStyle: StaveStyle) -> [Path] {
        
        let barRange = (bars.first!.barNumber)...(bars.last!.barNumber)
        print("Creating paths for bar range \(barRange)")
        
        var paths = bars.map {
            makePaths(forBar: $0, inRange: barRange, canvasWidth: canvasWidth, leadingTies: leadingTies)
        }.joined().toArray()
        
        // Make the path for the last barline
        if let lastBarline = bars.last?.trailingBarline {
            paths += barlineRenderer.paths(forBarline: lastBarline)
        }
        
        paths += StaveRenderer.stavePaths(withWidth: canvasWidth, style: staveStyle)
        return paths
    }
    
    private func makePaths(forBar bar: Bar, inRange barRange: ClosedRange<Int>, canvasWidth: Double, leadingTies: [Tie]) -> [Path] {
        
        let barlinePath = barlineRenderer.paths(forBarline: bar.leadingBarline)
        let clefPath = bar.isFirstBarInLine ? glyphRenderer.paths(forRenderable: bar.clefSymbol) : []

        var timeSigaturePaths = [Path]()
        if let timeSignatureSymbol = bar.timeSignatureSymbol {
            timeSigaturePaths = timeSignatureRenderer.paths(forTimeSignatureSymbol: timeSignatureSymbol)
        }
        
        let notePaths =  bar.sequences.map {
            makePaths(forNoteSequence: $0, inRange: barRange, canvasWidth: canvasWidth, leadingTies: leadingTies)
        }.joined().toArray()
        
        return barlinePath + clefPath + timeSigaturePaths + notePaths
    }
    
    private func makePaths(forNoteSequence noteSequence: NoteSequence,
                           inRange barRange: ClosedRange<Int>,
                           canvasWidth: Double,
                           leadingTies: [Tie]) -> [Path] {

        // Notes
        let notePaths = noteRenderer.paths(forNotes: noteSequence.notes)

        // Grace notes
        var graceNotePaths = [Path]()
        for note in noteSequence.notes {
            graceNotePaths += makeGraceNotesPaths(forNote: note)
        }

        // Adjacent items
        let noteHeadAdjacentItems = noteSequence.notes.map { $0.noteHeads }.joined().map { $0.trailingLayoutItems + $0.leadingLayoutItems }.joined().map(makePaths).joined().toArray()

        // Rests
        let restPaths = noteSequence.rests.map(glyphRenderer.paths).joined()
        
        let articulationMarkPaths = noteSequence.notes.map { note in
            note.articulationMarks.map { makePaths(forArticulationMark: $0, xPos: note.xPosition) }.joined()
        }.joined().toArray()

        let tupletMarkPaths = tupletMarksRenderer.paths(forNoteSequence: noteSequence)
        
        // Draw ties
        var tiePaths = [Path]()
        for note in noteSequence.notes {
            for noteHeadDescription in note.noteHeads {
                if let tie = noteHeadDescription.tie?.chosenVariation {
                    tiePaths += tieRenderer.paths(forTie: tie,
                                                  inBarRange: barRange,
                                                  canvasWidth: canvasWidth)
                }
            }
        }
        
        // Draw leading ties
        var leadingTiePaths = [Path]()
        for tie in leadingTies {
            leadingTiePaths += tieRenderer.paths(forTie: tie,
                                                 inBarRange: barRange,
                                                 canvasWidth: canvasWidth)
        }
        
        var allPaths = [Path]()
        allPaths += notePaths
        allPaths += graceNotePaths
        allPaths += noteHeadAdjacentItems
        allPaths += restPaths
        allPaths += tiePaths
        allPaths += leadingTiePaths
        allPaths += articulationMarkPaths
        allPaths += tupletMarkPaths
        allPaths += makeFloatingArticulationPaths(for: noteSequence)
        allPaths += makeStemAugmentationPaths(for: noteSequence)
        return allPaths
    }

    // MARK: - Render Grace Notes

    private func makeGraceNotesPaths(forNote note: Note) -> [Path] {
        return graceNoteRenderer.paths(forGraceNotes: note.graceNotes)
    }

    // MARK: - Render Symbols
    
    private func makePaths(forSymbol symbol: AdjacentLayoutItem) -> [Path] {

        if let singleGlyphRenderable = symbol as? SingleGlyphRenderable {
            return glyphRenderer.paths(forRenderable: singleGlyphRenderable)
        } else {
            fatalError("Unknown symbol type: \(symbol)")
        }
    }

    // MARK: - Render stem augmentations

    private func makeStemAugmentationPaths(for noteSequence: NoteSequence) -> [Path] {
        var paths = [Path]()

        for note in noteSequence.notes {
            if let stemAugmentation = note.stemAugmentation {
                let augmentationPaths = glyphRenderer.paths(forGlyph: stemAugmentation.glyphType,
                                                            position: note.stemAugmentationAttachmentPoint)
                paths += augmentationPaths
            }
        }
        return paths
    }
    
    // MARK: - Render Articulation

    private func makeFloatingArticulationPaths(for noteSequence: NoteSequence) -> [Path] {
        var paths = [Path]()

        for note in noteSequence.notes {
            for mark in note.floatingArticulationMarks {
                paths += makePaths(forArticulationMark: mark, xPos: note.xPosition, scale: 1)
            }
            for graceNote in note.graceNotes {
                for mark in graceNote.floatingArticulationMarks {
                    paths += makePaths(forArticulationMark: mark,
                                       xPos: graceNote.xPosition,
                                       scale: metrics.graceNoteScale)
                }
            }
        }

        return paths
    }
    
    private func makePaths(forArticulationMark articulation: ArticulationMark, xPos: Double) -> [Path] {
        
        if let accent = articulation as? Accent {
            return AccentRenderer().paths(forAccent: accent, xPos: xPos)
        } else if let textArticulation = articulation as? TextArticulation {
            return TextArticulationRenderer().paths(forTextArticulation: textArticulation, xPos: xPos)
        } else {
            fatalError("Unknown articulation type: \(articulation)")
        }
    }

    private func makePaths(forArticulationMark articulation: FloatingArticulationMark, xPos: Double, scale: Double) -> [Path] {

        if let textArticulation = articulation as? FloatingTextArticulation {
            return FloatingTextArticulationRenderer().paths(forTextArticulation: textArticulation, xPos: xPos, scale: scale)
        } else {
            fatalError("Unknown articulation type: \(articulation)")
        }
    }
}
