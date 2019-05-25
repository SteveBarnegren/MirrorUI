//
//  NoteValueTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 12/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteValueTests: XCTestCase {
    
    // MARK: - Duration
    
    func test_Duration() {
        
        // Basic notes
        NoteValue(division: 1).verify(duration: Time(value: 1, division: 1))
        NoteValue(division: 2).verify(duration: Time(value: 1, division: 2))
        NoteValue(division: 4).verify(duration: Time(value: 1, division: 4))
        NoteValue(division: 8).verify(duration: Time(value: 1, division: 8))
        NoteValue(division: 16).verify(duration: Time(value: 1, division: 16))
        NoteValue(division: 32).verify(duration: Time(value: 1, division: 32))

        // Dotted notes
        NoteValue(division: 1, dots: .dotted).verify(duration: Time(value: 3, division: 2))
        NoteValue(division: 2, dots: .dotted).verify(duration: Time(value: 3, division: 4))
        NoteValue(division: 4, dots: .dotted).verify(duration: Time(value: 3, division: 8))
        NoteValue(division: 8, dots: .dotted).verify(duration: Time(value: 3, division: 16))
        NoteValue(division: 16, dots: .dotted).verify(duration: Time(value: 3, division: 32))
        NoteValue(division: 32, dots: .dotted).verify(duration: Time(value: 3, division: 64))
        
        // Double dotted notes
        NoteValue(division: 1, dots: .doubleDotted).verify(duration: Time(value: 7, division: 4))
        NoteValue(division: 2, dots: .doubleDotted).verify(duration: Time(value: 7, division: 8))
        NoteValue(division: 4, dots: .doubleDotted).verify(duration: Time(value: 7, division: 16))
        NoteValue(division: 8, dots: .doubleDotted).verify(duration: Time(value: 7, division: 32))
        NoteValue(division: 16, dots: .doubleDotted).verify(duration: Time(value: 7, division: 64))
        NoteValue(division: 32, dots: .doubleDotted).verify(duration: Time(value: 7, division: 128))
    }

}
