//
//  PlayableItemTimeCalculatorTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 25/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class PlayableItemTimeCalculatorTests: XCTestCase {

    let calculator = PlayableItemTimeCalculator()
    
    // MARK: - Basic single note type
    
    func test_FourCrotchets() {
        
        let sequence = calulateSequence(noteWithValues: [.crotchet, .crotchet, .crotchet, .crotchet])
        sequence.verify(noteTimes: [
            .init(crotchets: 0),
            .init(crotchets: 1),
            .init(crotchets: 2),
            .init(crotchets: 3)
        ])
    }
    
    func test_FourQuavers() {
        
        let sequence = calulateSequence(noteWithValues: [.quaver, .quaver, .quaver, .quaver])
        sequence.verify(noteTimes: [
            .init(quavers: 0),
            .init(quavers: 1),
            .init(quavers: 2),
            .init(quavers: 3)
            ])
    }
    
    // MARK: - Just Dotted Notes
    
    func test_FourDottedCrotchets() {
        
        let sequence = calulateSequence(noteWithValues: [.dottedCrotchet, .dottedCrotchet, .dottedCrotchet, .dottedCrotchet])
        sequence.verify(noteTimes: [
            .init(quavers: 0),
            .init(quavers: 3),
            .init(quavers: 6),
            .init(quavers: 9)
            ])
    }
    
    func test_FourDottedQuavers() {
        
        let sequence = calulateSequence(noteWithValues: [.dottedQuaver, .dottedQuaver, .dottedQuaver, .dottedQuaver])
        sequence.verify(noteTimes: [
            .init(semiquavers: 0),
            .init(semiquavers: 3),
            .init(semiquavers: 6),
            .init(semiquavers: 9)
            ])
    }
    
    // MARK: - Just Double Dotted Notes
    
    func test_FourDoubleDottedCrotchets() {
        
        let sequence = calulateSequence(noteWithValues: .init(repeating: .doubleDottedCrotchet, count: 4))
        sequence.verify(noteTimes: [
            .init(semiquavers: 0),
            .init(semiquavers: 7),
            .init(semiquavers: 14),
            .init(semiquavers: 21)
            ])
    }
    
    func test_FourDoubleDottedQuavers() {
        
        let sequence = calulateSequence(noteWithValues: .init(repeating: .doubleDottedQuaver, count: 4))
        sequence.verify(noteTimes: [
            .init(value: 0, division: 32),
            .init(value: 7, division: 32),
            .init(value: 14, division: 32),
            .init(value: 21, division: 32),
            ])
    }
    
    // MARK: - Mixed basic note types
    
    func test_MixedCrotchetsAndQuavers() {
        
        let sequence = calulateSequence(noteWithValues: [.crotchet, .quaver, .quaver, .crotchet, .quaver, .semiquaver, .semiquaver])
        sequence.verify(noteTimes: [
            .init(semiquavers: 0), // crotchet
            .init(semiquavers: 4), // quaver
            .init(semiquavers: 6), // quaver
            .init(semiquavers: 8), // crotchet
            .init(semiquavers: 12), // quaver
            .init(semiquavers: 14), // semiquaver
            .init(semiquavers: 15) // semiquaver
            ])
    }
    
    
    
}

// MARK: - Helpers

extension PlayableItemTimeCalculatorTests {
    
    func calulateSequence(noteWithValues values: [NoteValue]) -> NoteSequence {
        
        let sequence = NoteSequence()
        
        for value in values {
           sequence.add(note: Note(value: value, pitch: .a3))
        }
        
        calculator.process(noteSequence: sequence)
        
        return sequence
    }
}

// MARK: - NoteSequence+Verify

extension NoteSequence {
    
    @discardableResult func verify(noteTimes: [Time], file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(noteTimes, self.playables.map { $0.time }, file: file, line: line)
        return self
    }
    
    
}
