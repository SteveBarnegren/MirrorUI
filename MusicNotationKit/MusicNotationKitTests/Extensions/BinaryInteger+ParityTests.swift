import XCTest
@testable import MusicNotationKit

class BinaryInteger_ParityTests: XCTestCase {
    
    func testEvenNumbers() {
        
        let evenNumbers = [2, 4, 6, 8, 10, 12, 14]
        evenNumbers.forEach {
            XCTAssert($0.isEven)
        }
    }
    
    func testOddNumbers() {
        
        let oddNumbers = [1, 3, 5, 7, 9, 11, 13]
        oddNumbers.forEach {
            XCTAssert($0.isOdd)
        }
    }
}
