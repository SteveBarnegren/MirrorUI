//
//  Rest.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Rest: Playable, Positionable {
    
    var symbolDescription = RestSymbolDescription.standard
    
    // Playable
    var value: NoteValue
    var compositionTime = CompositionTime.zero
    
    // HorizontalLayoutItem
    var barTime = Time.zero
    var horizontalLayoutWidth: HorizontalLayoutWidthType { .centeredOnGlyph(glyph) }
    let leadingChildItems = [AdjacentLayoutItem]()
    let trailingChildItems = [AdjacentLayoutItem]()
    
    // Positionable
    var position = Vector2D.zero
    
    // Horizontally Constrained
    var layoutDuration: Time? { return self.duration }
    
    // MARK: - Init
    public init(value: NoteValue) {
        self.value = value
    }
}

class RestSymbolDescription {
    
    enum Style {
        case none
        case whole
        case half
        case crotchet
        case tailed(TailedRestStyle)
    }
    
    var style: Style
    
    static var standard: RestSymbolDescription {
        return RestSymbolDescription(style: .none)
    }
    
    init(style: Style) {
        self.style = style
    }
}

struct TailedRestStyle {
    let numberOfTails: Int
}

// MARK: - Single Glyph Renderable

extension Rest: SingleGlyphRenderable {
    
    var glyph: GlyphType {
        
        switch symbolDescription.style {
        case .none:
            fatalError("No symbol description")
        case .whole:
            return .restWhole
        case .half:
            return .restHalf
        case .crotchet:
            return .restQuarter
        case .tailed(let tailedStyle):
            switch tailedStyle.numberOfTails {
            case 1: return .rest8th
            case 2: return .rest16th
            case 3: return .rest32nd
            case 4: return .rest64th
            case 5: return .rest128th
            case 6: return .rest256th
            case 7: return .rest512th
            case 8: return .rest1024th
            default:
                print("No available glyph for rest with \(tailedStyle.numberOfTails) tails. Using 1024th note rest glyph")
                return .rest1024th
            }
        }
    }
}
