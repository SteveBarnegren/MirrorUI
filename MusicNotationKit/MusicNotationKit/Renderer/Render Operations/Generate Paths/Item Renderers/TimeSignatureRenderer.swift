//
//  TimeSignatureRenderer.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 09/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

class TimeSignatureRenderer {

    private let glyphs: GlyphStore

    init(glyphs: GlyphStore) {
        self.glyphs = glyphs
    }

    func paths(forTimeSignatureSymbol timeSignatureSymbol: TimeSignatureSymbol) -> [Path] {

        let layout = TimeSignatureGlyphLayout(top: timeSignatureSymbol.topNumber,
                                              bottom: timeSignatureSymbol.bottomNumber,
                                              glyphStore: glyphs)

        var paths = [Path]()

        layout.visitGlyphsWithPosition { glyph, position in
            let path = glyph.path.translated(x: timeSignatureSymbol.position.x + position.x,
                                             y: position.y)
            paths.append(path)
        }

        return paths
    }
}
