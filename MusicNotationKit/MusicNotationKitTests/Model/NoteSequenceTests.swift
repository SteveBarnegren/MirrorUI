//
//  NoteSequenceTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 13/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteSequenceTests: XCTestCase {
    
    // MARK: - Access playable items
    
    func test_NotesPropertyReturnsNotes() {
        
        let note1 = Note(value: .quarter, pitch: .a3)
        let note2 = Note(value: .quarter, pitch: .a4)
        let rest = Rest(value: .quarter)
        
        let sequence = NoteSequence()
        sequence.add(note: note1)
        sequence.add(note: note2)
        sequence.add(rest: rest)
        
        sequence.notes.verify(containsInstances: [note1, note2])
    }
    
    func test_RestsPropertyReturnsRests() {
        
        let rest1 = Rest(value: .quarter)
        let rest2 = Rest(value: .quarter)
        let note = Note(value: .quarter, pitch: .a3)
        
        let sequence = NoteSequence()
        sequence.add(rest: rest1)
        sequence.add(rest: rest2)
        sequence.add(note: note)
        
        sequence.rests.verify(containsInstances: [rest1, rest2])
    }
    
    // MARK: - Duration
    
    func test_DurationReturnsSumOfPlayableItemsDuration() {
        
        let sequence = NoteSequence()
        sequence.add(note: Note(value: .quarter, pitch: .a3))
        sequence.add(note: Note(value: .quarter, pitch: .a3))
        sequence.add(rest: Rest(value: .quarter))
        sequence.add(rest: Rest(value: .quarter))
        
        XCTAssertEqual(sequence.duration, Time(crotchets: 4))
    }
}
