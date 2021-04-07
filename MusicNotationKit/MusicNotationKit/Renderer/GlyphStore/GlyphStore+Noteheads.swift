//
//  GlyphStore+Noteheads.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension GlyphStore {
    
    func glyph(forNoteHeadStyle style: NoteHead.Style) -> Glyph? {
        switch style {
        case .none:
            return nil
        case .semibreve:
            return self.glyph(forType: .noteheadWhole)
        case .open:
            return self.glyph(forType: .noteheadHalf)
        case .filled:
            return self.glyph(forType: .noteheadBlack)
        case .cross:
            return self.glyph(forType: .noteheadXBlack)
        }
    }
}
