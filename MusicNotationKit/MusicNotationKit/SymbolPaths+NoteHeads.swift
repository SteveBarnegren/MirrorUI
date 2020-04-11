//
//  SymbolPaths+NoteHeads.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 11/04/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension SymbolPaths {
    
    static func path(forNoteHeadStyle style: NoteHeadDescription.Style) -> Path? {
        switch style {
        case .none:
            return nil
        case .semibreve:
            return SymbolPaths.semibreve
        case .open:
            return SymbolPaths.openNoteHead
        case .filled:
            return SymbolPaths.filledNoteHead
        case .cross:
            return SymbolPaths.crossNoteHead
        }
    }
}
