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
            return noteheadWhole
        case .open:
            return noteheadHalf
        case .filled:
            return noteheadFilled
        case .cross:
            return noteheadCross
        }
    }
}
