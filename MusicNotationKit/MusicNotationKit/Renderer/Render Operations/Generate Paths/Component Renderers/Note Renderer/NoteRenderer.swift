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

        let stemDirection = notes[0].stemDirection
        
        // Draw notes with stems
        for note in notes {
            paths += makeHeadPaths(forNote: note)
            paths.append(maybe: makeStemPath(forNote: note))
        }
        
        // Draw beams
        let maxBeams = notes.map { $0.beams.count }.max() ?? 0
        var beamStartNotes = [Note?](repeating: nil, count: maxBeams)
        
        for note in notes {
            for (beamIndex, beam) in note.beams.enumerated() {
                switch beam {
                case .connectedNext:
                    beamStartNotes[beamIndex] = note
                case .connectedPrevious:
                    if let startNote = beamStartNotes[beamIndex] {
                        let path = makeBeamPath(fromNote: startNote, toNote: note, beamIndex: beamIndex)
                        paths.append(path)
                    }
                    beamStartNotes[beamIndex] = nil
                case .connectedBoth:
                    break
                case .cutOffLeft:
                    let beamY: Double
                    if stemDirection == .up {
                        beamY = notes.map { $0.stemConnectingNoteHead.yPosition + $0.stemEndOffset }.max()!
                    } else {
                        beamY = notes.map { $0.stemConnectingNoteHead.yPosition + $0.stemEndOffset }.min()!
                    }
                    let path = makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beamIndex, rightSide: false)
                    paths.append(path)
                case .cutOffRight:
                    let beamY: Double
                    if stemDirection == .up {
                        beamY = notes.map { $0.stemConnectingNoteHead.yPosition + $0.stemEndOffset }.max()!
                    } else {
                        beamY = notes.map { $0.stemConnectingNoteHead.yPosition + $0.stemEndOffset }.min()!
                    }
                    let path = makeCutOffBeamPath(forNote: note, beamYPosition: beamY, beamIndex: beamIndex, rightSide: true)
                    paths.append(path)
                }
            }
        }
        
        return paths
    }
    
    private func makeBeamPath(fromNote: Note, toNote: Note, beamIndex: Int) -> Path {
        
        let stemDirection = fromNote.stemDirection
        
        let startX = fromNote.stemTrailingEdge
        let endX = toNote.stemLeadingEdge
        let eachBeamYOffset = (beamSeparation + beamThickness).inverted(if: { stemDirection == .down })
        
        let thickness = beamThickness.inverted(if: { stemDirection == .down })
        let startY = fromNote.stemConnectingNoteHead.yPosition + fromNote.stemEndOffset
        let endY = toNote.stemConnectingNoteHead.yPosition + toNote.stemEndOffset
        
        let startPoint = Vector2D(startX, startY - (Double(beamIndex) * eachBeamYOffset))
        let endPoint = Vector2D(endX, endY - (Double(beamIndex) * eachBeamYOffset))

        let commmands: [Path.Command] = [
            .move(startPoint),
            .line(Vector2D(startPoint.x, startPoint.y - thickness)),
            .line(Vector2D(endPoint.x, endPoint.y - thickness)),
            .line(endPoint),
            .close
        ]
        
        var path = Path(commands: commmands)
        path.drawStyle = .fill
        
        return path
    }
    
    private func makeCutOffBeamPath(forNote note: Note, beamYPosition: Double, beamIndex: Int, rightSide: Bool) -> Path {
        
        let stemDirection = note.stemDirection
        let height = beamThickness
        let width = 0.85
        
        let x: Double
        if rightSide {
            x = note.stemTrailingEdge
        } else {
            x = note.stemLeadingEdge - width
        }
        
        let eachBeamYOffset = (beamSeparation + height).inverted(if: { stemDirection == .up })
        let beamRect = Rect(x: x,
                            y: beamYPosition + (Double(beamIndex) * eachBeamYOffset),
                            width: width,
                            height: height.inverted(if: { stemDirection == .up }))
        
        var path = Path(rect: beamRect)
        path.drawStyle = .fill
        return path
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
