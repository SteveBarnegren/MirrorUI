import XCTest
@testable import MusicNotationKit

class NoteHeadDescriberTests: XCTestCase {
    
    let describer = NoteHeadDescriber()
    
    // MARK: - Single note heads
    
    func test_Semibreve() {
        
        let note = Note(value: .whole, pitch: .a3)
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)
        
        XCTAssertEqual(descriptions.count, 1)
        descriptions[maybe: 0]?.verify(style: .semibreve)
    }
    
    func test_Minim() {
        
        let note = Note(value: .minim, pitch: .a3)
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)
        
        XCTAssertEqual(descriptions.count, 1)
        descriptions[maybe: 0]?.verify(style: .open)
    }
    
    func test_Crotchet() {
        
        let note = Note(value: .crotchet, pitch: .a3)
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)
        
        XCTAssertEqual(descriptions.count, 1)
        descriptions[maybe: 0]?.verify(style: .filled)
    }
    
    func test_Quaver() {
        
        let note = Note(value: .quaver, pitch: .a3)
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)
        
        XCTAssertEqual(descriptions.count, 1)
        descriptions[maybe: 0]?.verify(style: .filled)
    }
    
    // MARK: - Multiple note heads
    
    func test_TwoCrotchets() {
        
        let note = Note(value: .crotchet, pitches: [.a3, .c3])
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)
        
        XCTAssertEqual(descriptions.count, 2)
        descriptions[maybe: 0]?.verify(style: .filled)
        descriptions[maybe: 1]?.verify(style: .filled)
    }
    
    // MARK: - Crossed note head
    
    func test_CrossedNoteHead() {
        
        let note = Note(value: .crotchet, pitch: .a3).crossHead()
        let descriptions = describer.noteHeadDescriptions(forNote: note, clef: .treble)

        XCTAssertEqual(descriptions.count, 1)
        descriptions[maybe: 0]?.verify(style: .cross)
    }
}
