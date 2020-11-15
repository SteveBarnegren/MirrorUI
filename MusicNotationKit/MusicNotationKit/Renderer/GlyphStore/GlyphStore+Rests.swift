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
        case .whole:
            return self.restWhole
        case .half:
            return self.restHalf
        case .crotchet:
            return self.restQuarter
        case .tailed(let tailedStyle):
            switch tailedStyle.numberOfTails {
            case 1: return self.rest8th
            case 2: return self.rest16th
            case 3: return self.rest32nd
            case 4: return self.rest64th
            case 5: return self.rest128th
            case 6: return self.rest256th
            case 7: return self.rest512th
            case 8: return self.rest1024th
            default:
                print("No available glyph for rest with \(tailedStyle.numberOfTails) tails. Using 1024th note rest glyph")
                return self.rest1024th
            }
        }
    }
}
