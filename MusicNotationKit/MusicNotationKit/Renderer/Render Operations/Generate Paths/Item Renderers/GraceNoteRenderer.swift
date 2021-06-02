//
//  GraceNoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

private let scale = 0.5
private let stemThickness = 0.12 * scale

class GraceNoteRenderer {

    private let glyphs: GlyphStore
    private let beamRenderer = BeamRenderer<GraceNote>.init(transformer: .graceNotes,
                                                            beamSeparation: 0.3 * scale,
                                                            beamThickness: 0.3 * scale)

    private var noteheadGlyph: Glyph {
        return glyphs.glyph(forType: .noteheadBlack)
    }

    private var noteheadPath: Path {
        return noteheadGlyph.path.scaled(scale)
    }

    private var noteHeadWidth: Double {
        return noteheadGlyph.width * scale
    }

    private var stemUpSE: Vector2D {
        return noteheadGlyph.stemUpSE * scale
    }

    private var flagGlyph: Glyph {
        return glyphs.glyph(forType: .flag8thUp)
    }

    private var flagPath: Path {
        return flagGlyph.path.scaled(scale)
    }

    private var flagStemUpNW: Vector2D {
        return flagGlyph.stemUpNW * scale
    }

    private var slashGliph: Glyph {
        return glyphs.glyph(forType: .graceNoteSlashStemUp)
    }

    private var slashPath: Path {
        return slashGliph.path.scaled(scale)
    }

    private var slashSW: Vector2D {
        return flagGlyph.graceNoteSlashSW * scale
    }

    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }

    func paths(forGraceNotes graceNotes: [GraceNote]) -> [Path] {
        var paths = [Path]()

        paths += graceNotes.map(headPath)
        paths += graceNotes.map(stemPath)
        if graceNotes.count > 1 {
            paths += beamRenderer.beamPaths(forNotes: graceNotes)
        } else {
            paths += graceNotes.map(flagPaths).joined()
        }

        return paths
    }

    private func headPath(forGraceNote note: GraceNote) -> Path {

        let path = noteheadPath.translated(x: note.position.x - noteHeadWidth / 2,
                                           y: note.position.y)
        return path
    }

    private func stemPath(forGraceNote note: GraceNote) -> Path {

        let x = note.xPosition - noteHeadWidth/2
        let y = note.yPosition

        var path = Path(rect: Rect(x: x + stemUpSE.x - stemThickness,
                                   y: y + stemUpSE.y,
                                   width: stemThickness,
                                   height: note.stemLength - stemUpSE.y))
        path.drawStyle = .fill
        return path
    }

    private func flagPaths(forGraceNote note: GraceNote) -> [Path] {

        // Flag
        let attatchX = note.xPosition + noteHeadWidth/2 - stemThickness
        let attatchY = note.yPosition + note.stemLength

        let flagPos = Vector2D(attatchX - flagStemUpNW.x, attatchY - flagStemUpNW.y)
        let flagPath = flagPath.translated(flagPos)

        // Slash
        let slashPath = slashPath.translated(flagPos + slashSW)

        return [flagPath, slashPath]
    }

}
