//
//  NoteBeamDescriberTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 25/05/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteBeamDescriberTests: XCTestCase {
    
    // MARK: - Basic single value notes
    
    func test_FourCrotchets() {
        //XCTFail()
    }
    

}

// MARK: - Helpers

extension NoteBeamDescriberTests {
    
    func processedSequence(notesWithValues values: [NoteValue]) -> NoteSequence {
        
        let sequence = NoteSequence()
        
        for value in values {
            sequence.add(note: Note(value: value, pitch: .a3))
        }
        
        // Process with the previous steps first
        
        
        
        return sequence
    }
    
    
    
}
