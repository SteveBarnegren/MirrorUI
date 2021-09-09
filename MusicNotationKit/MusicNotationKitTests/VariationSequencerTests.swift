import XCTest
@testable import MusicNotationKit

class VariationSequencerTests: XCTestCase {

    func test_ThreeSets() {
        
        let setA = VariationSet<String>(variations: [
            Variation(value: "a1", suitability: .preferable),
            Variation(value: "a2", suitability: .preferable),
            Variation(value: "a3", suitability: .concession)
        ])
        
        let setB = VariationSet<String>(variations: [
            Variation(value: "b1", suitability: .preferable),
            Variation(value: "b2", suitability: .allowed),
            Variation(value: "b3", suitability: .allowed)
        ])
        
        let setC = VariationSet<String>(variations: [
            Variation(value: "c1", suitability: .preferable),
            Variation(value: "c2", suitability: .preferable),
            Variation(value: "c3", suitability: .allowed)
        ])
        
        var sequencer = VariationSequencer<String>(variationSets: [setA, setB, setC])
        
        XCTAssertEqual(sequencer.next(), ["a1", "b1", "c1"]) // preferred  preferred  preferred
        XCTAssertEqual(sequencer.next(), ["a2", "b1", "c1"]) // preferred  ↓↓↓↓↓↓↓↓↓  ↓↓↓↓↓↓↓↓↓
        XCTAssertEqual(sequencer.next(), ["a2", "b1", "c2"]) // ↓↓↓↓↓↓↓↓↓  ↓↓↓↓↓↓↓↓↓  preferred
        XCTAssertEqual(sequencer.next(), ["a2", "b2", "c2"]) // ↓↓↓↓↓↓↓↓↓  allowed    ↓↓↓↓↓↓↓↓↓
        XCTAssertEqual(sequencer.next(), ["a2", "b3", "c2"]) // ↓↓↓↓↓↓↓↓↓  allowed    ↓↓↓↓↓↓↓↓↓
        XCTAssertEqual(sequencer.next(), ["a2", "b3", "c3"]) // ↓↓↓↓↓↓↓↓↓  ↓↓↓↓↓↓↓↓↓  allowed
        XCTAssertEqual(sequencer.next(), ["a3", "b3", "c3"]) // concession ↓↓↓↓↓↓↓↓↓  ↓↓↓↓↓↓↓↓↓
        XCTAssertNil(sequencer.next())
    }
    
    func test_DifferentLengthSets() {
     
        let setA = VariationSet<String>(variations: [
            Variation(value: "a1", suitability: .preferable),
            Variation(value: "a2", suitability: .allowed)
        ])
        
        let setB = VariationSet<String>(variations: [
            Variation(value: "b1", suitability: .preferable),
            Variation(value: "b2", suitability: .preferable),
            Variation(value: "b3", suitability: .allowed),
            Variation(value: "b4", suitability: .allowed),
            Variation(value: "b5", suitability: .concession),
            Variation(value: "b6", suitability: .concession)
        ])
        
        var sequencer = VariationSequencer<String>(variationSets: [setA, setB])
        
        XCTAssertEqual(sequencer.next(), ["a1", "b1"]) // preferred preferred
        XCTAssertEqual(sequencer.next(), ["a1", "b2"]) // ↓↓↓↓↓↓↓↓↓ preferred
        XCTAssertEqual(sequencer.next(), ["a2", "b2"]) // allowed   ↓↓↓↓↓↓↓↓↓
        XCTAssertEqual(sequencer.next(), ["a2", "b3"]) // ↓↓↓↓↓↓↓↓↓ allowed
        XCTAssertEqual(sequencer.next(), ["a2", "b4"]) // ↓↓↓↓↓↓↓↓↓ allowed
        XCTAssertEqual(sequencer.next(), ["a2", "b5"]) // ↓↓↓↓↓↓↓↓↓ concession
        XCTAssertEqual(sequencer.next(), ["a2", "b6"]) // ↓↓↓↓↓↓↓↓↓ concession
        XCTAssertNil(sequencer.next())
    }

}
