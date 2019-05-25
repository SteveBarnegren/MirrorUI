//
//  NoteValue.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

public struct NoteValue {
    
    // MARK: - Static conviniences
    
    public static let whole = NoteValue(division: 1)
    public static let half = NoteValue(division: 2)
    public static let quarter = NoteValue(division: 4)
    public static let eighth = NoteValue(division: 8)
    public static let sixteenth = NoteValue(division: 16)
    
    // MARK: - Types
    
    public enum Dots {
        case none
        case dotted
        case doubleDotted
    }
    
    // MARK: - Properties
    
    var division: Int
    var dots: Dots
    
    var duration: Time {
        switch dots {
        case .none:
            return Time(value: 1, division: division)
        case .dotted:
            return Time(value: 3, division: division * 2)
        case .doubleDotted:
            return Time(value: 7, division: division * 2 * 2)
        }
    }
    
    // MARK: - Init
    
    public init(division: Int, dots: Dots = .none) {
        self.division = division
        self.dots = dots
    }
}
