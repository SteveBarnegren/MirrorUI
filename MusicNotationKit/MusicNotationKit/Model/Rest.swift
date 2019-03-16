//
//  Rest.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public class Rest: Playable {
    
    var symbolDescription = RestSymbolDescription.standard
    
    // Playable
    var value: NoteValue
    var time = Time.zero
    
    // Positionable
    var position = Point.zero
    
    // Horizontally Constrained
    var layoutDuration: Time? { return self.duration }
    var leadingConstraints = [HorizontalConstraint]()
    var trailingConstraints = [HorizontalConstraint]()
    
    // MARK: - Init
    public init(value: NoteValue) {
        self.value = value
    }
}

class RestSymbolDescription {
    
    enum Style {
        case none
        case crotchet
        case minim
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
