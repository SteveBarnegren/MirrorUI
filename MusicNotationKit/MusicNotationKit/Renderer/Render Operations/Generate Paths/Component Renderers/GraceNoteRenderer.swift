//
//  GraceNoteRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class GraceNoteRenderer {

    private let glyphs: GlyphStore

    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }

    func paths(forGraceNotes graceNotes: [GraceNote]) -> [Path] {
        return graceNotes.map(paths(forGraceNote:)).joined().toArray()
    }

    private func paths(forGraceNote note: GraceNote) -> [Path] {
        return [Path(circleWithCenter: note.position, radius: 0.3)]
    }

}
