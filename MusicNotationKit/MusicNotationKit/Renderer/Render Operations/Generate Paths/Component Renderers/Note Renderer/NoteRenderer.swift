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
        paths += makeHeadPaths(forNote: note)
        
        // Crotchet
        if note.numberOfTails == 0 {
            paths.append(maybe: makeStemPath(forNote: note))
        }
        
        // Quaver
        if note.numberOfTails == 1 {
            paths.append(maybe: makeStemPath(forNote: note))
            let isDown = note.stemDirection == .down

            let tailGlyph = glyphs.glyph(forType: isDown ? .flag8thDown : .flag8thUp)

            var pos = Vector2D(note.xPosition + note.stemConnectionPoint.x,
                               note.stemEndY)

            if isDown {
                pos -= tailGlyph.stemDownSW
            } else {
                pos -= tailGlyph.stemUpNW
                pos.x -= stemThickness
            }

            var path = tailGlyph.path.translated(pos)
            path.drawStyle = .fill
            paths.append(path)
        }
        
        // Semiquaver or faster
        if note.numberOfTails >= 2 {
            
            let stemDirection = note.stemDirection
            
            let bottomOffset = 2.2
            let eachTailYOffset = 0.5
            let tailsHeight = eachTailYOffset * Double(note.numberOfTails)
            let stemHeight = max(note.stemLength, tailsHeight + bottomOffset)

            paths.append(maybe: makeStemPath(forNote: note, to: note.stemConnectingNoteHead.yPosition + stemHeight.inverted(if: { stemDirection == .down })))
            
            for (tailNumber, isLast) in (0..<note.numberOfTails).eachWithIsLast() {
                let xOffset = note.stemConnectionPoint.x
                let yOffset = (stemHeight - Double(tailNumber) * eachTailYOffset).inverted(if: { note.stemDirection == .down })
                let commands = isLast ? makeFastNoteBottomTailCommands() : makeFastNoteTailCommands()
                
                var path = Path(commands: commands)
                
                if note.stemDirection == .down {
                    path.invertY()
                }
                path.translate(x: note.xPosition + xOffset,
                               y: note.stemConnectingNoteHead.yPosition + yOffset)
                
                path.drawStyle = .fill
                paths.append(path)
            }
        }
        
        return paths
    }
    
    // all tails
    private func makeFastNoteTailCommands() -> [Path.Command] {
        let commands: [Path.Command] = [
            .move(Vector2D(0.008714897856421211, 0.19140708577675658)), // 14
            .curve(Vector2D(0.2059272997832754, -0.07986761556367605), c1: Vector2D(0.18538248682111114, 0.04105231380363639), c2: Vector2D(0.1846982200696919, 0.07654361989015901)), // 15
            .line(Vector2D(0.21425213188790243, -0.0930725216606707)), // 3
            .curve(Vector2D(0.21683570047209705, 0.026919885916367292), c1: Vector2D(0.2210403262938127, -0.04268545684726699), c2: Vector2D(0.2213882927932591, -0.004074871766974408)), // 4
            .line(Vector2D(0.20363079437510245, 0.07543356266402135)), // 10
            .curve(Vector2D(0.008714897856421211, 0.3082417984175567), c1: Vector2D(0.16985480329407404, 0.15394531374787002), c2: Vector2D(0.08875637875071873, 0.17787456940425372)), // 11
            .close
            ].translated(x: -0.008714897856421211, y: -0.3082417984175567).scaled(4.2)
        return commands
    }
    
    // last tails
    private func makeFastNoteBottomTailCommands() -> [Path.Command] {
        let commands: [Path.Command] = [
            .move(Vector2D(0.008714897856421211, 0.026058696388302383)), // 1
            .curve(Vector2D(0.1792304244132646, -0.35229056960819516), c1: Vector2D(0.18226080108967335, -0.08849347359720644), c2: Vector2D(0.2675874595303402, -0.11050336514956877)), // 2
            .curve(Vector2D(0.21425213188790243, -0.0930725216606707), c1: Vector2D(0.26596924995952503, -0.24026207534583588), c2: Vector2D(0.2597177947976131, -0.16797185136542003)), // 3
            .line(Vector2D(0.2059272997832754, -0.07986761556367605)), // 15
            .curve(Vector2D(0.008714897856421211, 0.19140708577675658), c1: Vector2D(0.15769398041585103, -0.0070288758595288825), c2: Vector2D(0.07567144209624721, 0.07066417104630607)) // 16
            ].translated(x: -0.008714897856421211, y: -0.19140708577675658).scaled(4.2)
        return commands
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
    
//    private func makeBeamPath(fromNote: Note, toNote: Note, beamYPosition: Double, beamIndex: Int) -> Path {
//
//        let stemDirection = fromNote.symbolDescription.stemDirection
//
//        let beamStartX = fromNote.position.x + stemXOffset(for: stemDirection)
//        let beamEndX = toNote.position.x + stemXOffset(for: stemDirection)
//        let eachBeamYOffset = (beamSeparation + beamThickness).inverted(if: { stemDirection == .down })
//        let beamRect = Rect(x: beamStartX,
//                            y: beamYPosition - beamThickness.inverted(if: { stemDirection == .down }) - (Double(beamIndex) * eachBeamYOffset),
//                            width: beamEndX - beamStartX,
//                            height: beamThickness.inverted(if: { stemDirection == .down }))
//
//        var path = Path()
//        path.addRect(beamRect)
//        path.drawStyle = .fill
//        return path
//    }
    
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
