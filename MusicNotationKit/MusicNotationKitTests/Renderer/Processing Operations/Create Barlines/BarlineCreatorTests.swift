import XCTest
@testable import MusicNotationKit

class BarlineCreatorTests: XCTestCase {

    private let barlineCreator = BarlineCreator()

    // MARK: - Single Line

    func test_DefaultToSingleLine() {
        verify(preceedingOptions: [],
               trailingOptions: [],
               expectedLineType: .single)
    }

    // MARK: - Double line

    func test_LeadingDoubleLineIgnored() {
        verify(preceedingOptions: [.double],
               trailingOptions: [],
               expectedLineType: .single)
    }

    func test_TrailingDouble() {
        verify(preceedingOptions: [],
               trailingOptions: [.double],
               expectedLineType: .double)
    }

    // MARK: - Final line

    func test_LeadingFinalLine() {
        verify(preceedingOptions: [.final],
               trailingOptions: [],
               expectedLineType: .final)
    }

    func test_TrailingFinalLineIgnored() {
        verify(preceedingOptions: [],
               trailingOptions: [.final],
               expectedLineType: .single)
    }

    func test_FinalLineTakesPrecedenceOverDouble() {
        verify(preceedingOptions: [.final],
               trailingOptions: [.double],
               expectedLineType: .final)
    }

    // MARK: - Repeats

    func test_StartRepeat() {
        verify(preceedingOptions: [],
               trailingOptions: [.startRepeat],
               expectedLineType: .single,
               expectRepeatRight: true)
    }

    func test_EndRepeat() {
        verify(preceedingOptions: [.endRepeat],
               trailingOptions: [],
               expectedLineType: .single,
               expectRepeatLeft: true)
    }

    func test_PreceedingStartRepeatIgnored() {
        verify(preceedingOptions: [.startRepeat],
               trailingOptions: [],
               expectedLineType: .single,
               expectRepeatLeft: false,
               expectRepeatRight: false)
    }

    func test_TrailingEndRepeatIgnored() {
        verify(preceedingOptions: [],
               trailingOptions: [.endRepeat],
               expectedLineType: .single,
               expectRepeatLeft: false,
               expectRepeatRight: false)
    }
}

// MARK: - Verification

extension BarlineCreatorTests {

    private func verify(preceedingOptions: BarlineOptions,
                        trailingOptions: BarlineOptions,
                        expectedLineType: Barline.LineType,
                        expectRepeatLeft: Bool = false,
                        expectRepeatRight: Bool = false,
                        file: StaticString = #file,
                        line: UInt = #line) {

        let barline = barlineCreator.createBarline(leadingOptions: preceedingOptions,
                                                   trailingOptions: trailingOptions)
        XCTAssertEqual(barline.lineType, expectedLineType, file: file, line: line)
        XCTAssertEqual(barline.repeatLeft, expectRepeatLeft, file: file, line: line)
        XCTAssertEqual(barline.repeatRight, expectRepeatRight, file: file, line: line)
    }

}
