//
//  NoteSymbolDescriberTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 11/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteSymbolDescriberTests: XCTestCase {
    
    let describer = NoteSymbolDescriber()
    
    override func setUp() {
        super.setUp()
    }
    
    func test_SymbolDescriptionForSemibreve() {
        
        let note = Note(value: .whole, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .semibreve)
            .verify(hasStem: false)
            .verify(numberOfBeams: 0)
    }
    
    func test_SymbolDescriptionForMinim() {
        
        let note = Note(value: .half, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .open)
            .verify(hasStem: true)
            .verify(numberOfBeams: 0)
    }
    
    func test_SymbolDescriptionForCrotchet() {
        
        let note = Note(value: .quarter, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .filled)
            .verify(hasStem: true)
            .verify(numberOfBeams: 0)
    }
    
    func test_SymbolDescriptionForQuaver() {
        
        let note = Note(value: .eighth, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .filled)
            .verify(hasStem: true)
            .verify(numberOfBeams: 1)
    }
    
    func test_SymbolDescriptionForSemiquaver() {
        
        let note = Note(value: .sixteenth, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .filled)
            .verify(hasStem: true)
            .verify(numberOfBeams: 2)
    }
    
    func test_SymbolDescriptionForDemiSemiquaver() {
        
        let note = Note(value: .init(division: 32), pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(headStyle: .filled)
            .verify(hasStem: true)
            .verify(numberOfBeams: 3)
    }
}
