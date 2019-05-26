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
    
    public static let semibreve = NoteValue(division: 1)
    public static let minim = NoteValue(division: 2)
    public static let crotchet = NoteValue(division: 4)
    public static let quaver = NoteValue(division: 8)
    public static let semiquaver = NoteValue(division: 16)
    
    public static let dottedSemibreve = NoteValue(division: 1, dots: .dotted)
    public static let dottedMinim = NoteValue(division: 2, dots: .dotted)
    public static let dottedCrotchet = NoteValue(division: 4, dots: .dotted)
    public static let dottedQuaver = NoteValue(division: 8, dots: .dotted)
    public static let dottedSemiquaver = NoteValue(division: 16, dots: .dotted)
    
    public static let doubleDottedSemibreve = NoteValue(division: 1, dots: .doubleDotted)
    public static let doubleDottedMinim = NoteValue(division: 2, dots: .doubleDotted)
    public static let doubleDottedCrotchet = NoteValue(division: 4, dots: .doubleDotted)
    public static let doubleDottedQuaver = NoteValue(division: 8, dots: .doubleDotted)
    public static let doubleDottedSemiquaver = NoteValue(division: 16, dots: .doubleDotted)
    
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
