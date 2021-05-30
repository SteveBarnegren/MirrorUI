//
//  GraceNoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

private let scale = 0.5
private let stemThickness = 0.2 * scale

// Behind Bars suggests 2.25 stave spaces for grace note stem height
private let stemHeight = 2.25

class GraceNoteRenderer {

    private let glyphs: GlyphStore

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

    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }

    func paths(forGraceNotes graceNotes: [GraceNote]) -> [Path] {
        let headPaths = graceNotes.map(headPath).toArray()
        let stemPaths = graceNotes.map(stemPath).toArray()
        return headPaths + stemPaths
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
                                   height: stemHeight))
        path.drawStyle = .fill
        return path
    }

}
