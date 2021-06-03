//
//  NoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

class NoteRenderer {
    
    private let preferredStemHeight = 3.0
    private let beamThickness = 0.3
    private let beamSeparation = 0.3
    private let noteHeadWidth = 1.4
    
    private var stemThickness: Double { glyphs.metrics.stemThickness }
    
    private let glyphs: GlyphStore
    private lazy var beamRenderer = BeamRenderer<Note>(transformer: .notesBeamRenderer(withMetrics: glyphs.metrics),
                                                       beamSeparation: glyphs.metrics.beamSpacing,
                                                       beamThickness: glyphs.metrics.beamThickness)
    
    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }
    
    func paths(forNotes notes: [Note]) -> [Path] {
        
        var paths = [Path]()
        
        var noteCluster = [Note]()
        
        func renderNoteCluster() {
            guard noteCluster.isEmpty == false else { return }
            paths += makePaths(forNoteCluster: noteCluster)
            noteCluster.removeAll()
        }
        
        func isNoteLastInCluster(_ note: Note) -> Bool {
            return !note.beams.contains { $0 == .connectedNext || $0 == .connectedBoth }
        }
        
        for note in notes {
            if note.beams.isEmpty {
                renderNoteCluster()
                paths += makePaths(forNote: note)
            } else {
                noteCluster.append(note)
                if isNoteLastInCluster(note) {
                    renderNoteCluster()
                }
            }
        }
        renderNoteCluster()
        
        return paths
    }
    
    // MARK: - Isolated Notes

    private func makePaths(forNote note: Note) -> [Path] {

        var paths = [Path]()

        // Head
        paths += makeHeadPaths(forNote: note)

        // Stem
        paths.append(maybe: makeStemPath(forNote: note))

        // Tails
        if note.numberOfTails > 0 {
            paths.append(maybe: makeStemPath(forNote: note))
            let isDown = note.stemDirection == .down

            let tailGlyph = glyphs.tailGlyph(forNumTails: note.numberOfTails,
                                             stemDirection: note.stemDirection)

            var pos = Vector2D(note.xPosition + note.stemConnectionPoint.x,
                               note.stemEndY)

            if !isDown {
                pos.x -= stemThickness
            }

            var path = tailGlyph.path.translated(pos)
            path.drawStyle = .fill
            paths.append(path)
        }

        return paths
    }
    
    // MARK: - Note Clusters (connected with beams)

    private func makePaths(forNoteCluster notes: [Note]) -> [Path] {

        var paths = [Path]()

        // Draw notes with stems
        for note in notes {
            paths += makeHeadPaths(forNote: note)
            paths.append(maybe: makeStemPath(forNote: note))
        }

        // Draw beams
        paths += beamRenderer.beamPaths(forNotes: notes)

        return paths
    }
    
    // MARK: - Components
    
    private func makeHeadPaths(forNote note: Note) -> [Path] {
        
        var paths = [Path]()
        
        for noteHeadDescription in note.noteHeads {
            
            guard let glyph = glyphs.glyph(forNoteHeadStyle: noteHeadDescription.style) else {
                continue
            }
            
            let alignmentOffset = NoteHeadAligner.xOffset(forNoteHead: noteHeadDescription, glyphs: glyphs)

            paths.append(
                glyph.path.translated(x: note.xPosition - glyph.size.width/2 + alignmentOffset,
                                      y: noteHeadDescription.yPosition)
            )
        }
        
        return paths
    }
    
    // MARK: - Stems
    
    private func makeStemPath(forNote note: Note, to customStemEndY: Double? = nil) -> Path? {
        
        if note.hasStem == false {
            return nil
        }
        
        let stemEndY: Double
        switch (customStemEndY, note.stemDirection) {
        case let (value?, _):
            stemEndY = value
        case (nil, let direction):
            stemEndY = note.stemConnectingNoteHead.yPosition + note.stemEndOffset
        }
        
        guard let stemRect = self.stemRect(fromNote: note, to: stemEndY) else {
            return nil
        }
        
        var stemPath = Path(rect: stemRect)
        stemPath.drawStyle = .fill
        return stemPath
    }
    
    private func stemRect(fromNote note: Note, to stemEndY: Double) -> Rect? {
        
        if note.hasStem == false {
            return nil
        }
        
        let noteHead = note.stemConnectingNoteHead
        let glyph = glyphs.glyph(forNoteHeadStyle: noteHead.style)!
        
        if note.stemDirection == .up {
            let anchor = glyph.stemUpSE
            let connectPoint = Vector2D(note.xPosition - glyph.width/2 + anchor.x,
                                        noteHead.yPosition + anchor.y)
            
            let rect = Rect(x: connectPoint.x - stemThickness,
                            y: connectPoint.y,
                            width: stemThickness,
                            height: stemEndY - connectPoint.y)
            return rect
        } else {
            let anchor = glyph.stemDownNW
            let connectPoint = Vector2D(note.xPosition - glyph.width/2 + anchor.x,
                                        noteHead.yPosition + anchor.y)
            let height = connectPoint.y - stemEndY
            
            let rect = Rect(x: connectPoint.x,
                            y: connectPoint.y - height,
                            width: stemThickness,
                            height: height)
            return rect
        }
    }
}
