//
//  GlyphStore+Flags.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 30/05/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

extension GlyphStore {

    func tailGlyph(forNumTails numTails: Int, stemDirection: StemDirection) -> Glyph {

        let isDown = stemDirection == .down
        let glyphType: GlyphType

        switch numTails {
            case 0:
                fatalError()
            case 1: glyphType = isDown ? .flag8thDown : .flag8thUp
            case 2: glyphType = isDown ? .flag16thDown : .flag16thUp
            case 3: glyphType = isDown ? .flag32ndDown : .flag32ndUp
            case 4: glyphType = isDown ? .flag64thDown : .flag64thUp
            case 5: glyphType = isDown ? .flag128thDown : .flag128thUp
            case 6: glyphType = isDown ? .flag256thDown : .flag256thUp
            case 7: glyphType = isDown ? .flag512thDown : .flag512thUp
            case 8: glyphType = isDown ? .flag1024thDown : .flag1024thUp
            default: glyphType = isDown ? .flag1024thDown : .flag1024thUp
        }

        return glyph(forType: glyphType)
    }
}
