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
    var horizontalLayoutWidth = HorizontalLayoutWidthType.centered(width: 1.4)
    let leadingLayoutItems = [AdjacentLayoutItem]()
    let trailingLayoutItems = [AdjacentLayoutItem]()
    
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
        case crotchet
        case block(BlockRestStyle)
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

struct BlockRestStyle {
    
    // startY should be relative to the line that the rest should be attached to.
    // eg. A minim rest should start at 0 because it sits on the line
    // A whole rest should start at 0.5, because it hangs from the line above the one that it's attached to
    
    let startY: Double
    let height: Double
}
