//
//  GlyphStore+Rests.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 15/11/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension GlyphStore {
    
    func glyph(forRestStyle style: RestSymbolDescription.Style) -> Glyph? {
        
        switch style {
        case .none:
            return nil
        case .crotchet:
            return self.restQuarter
        case .block(_):
            return nil
        case .tailed(_):
            return nil
        }
    }
}
