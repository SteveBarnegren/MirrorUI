import XCTest
@testable import MusicNotationKit

class NoteSymbolDescriberTests: XCTestCase {
    
    let describer = NoteSymbolDescriber()
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - Basic Notes
    
    func test_SymbolDescriptionForSemibreve() {
        
        let note = Note(value: .whole, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: false)
            .verify(numberOfTails: 0)
    }
    
    func test_SymbolDescriptionForMinim() {
        
        let note = Note(value: .half, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
            .verify(numberOfTails: 0)
    }
    
    func test_SymbolDescriptionForCrotchet() {
        
        let note = Note(value: .quarter, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
            .verify(numberOfTails: 0)
    }
    
    func test_SymbolDescriptionForQuaver() {
        
        let note = Note(value: .eighth, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
            .verify(numberOfTails: 1)
    }
    
    func test_SymbolDescriptionForSemiquaver() {
        
        let note = Note(value: .sixteenth, pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
            .verify(numberOfTails: 2)
    }
    
    func test_SymbolDescriptionForDemiSemiquaver() {
        
        let note = Note(value: .init(division: 32), pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
            .verify(numberOfTails: 3)
    }
    
    // MARK: - Dotted Notes
    
    func test_SymbolDescriptionForDottedCrotchet() {
        
        let note = Note(value: .init(division: 4, dots: .dotted), pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
    }
    
    // MARK: - Double Dotted Notes
    
    func test_SymbolDescriptionForDoubleDottedCrotchet() {
        
        let note = Note(value: .init(division: 4, dots: .doubleDotted), pitch: .a3)
        describer.symbolDescription(forNote: note)
            .verify(hasStem: true)
    }
}

private extension NoteSymbolDescriber.Result {
    
    @discardableResult func verify(hasStem: Bool, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.hasStem, hasStem, file: file, line: line)
        return self
    }
    
    @discardableResult func verify(numberOfTails: Int, file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertEqual(self.numberOfTails, numberOfTails, file: file, line: line)
        return self
    }
}
