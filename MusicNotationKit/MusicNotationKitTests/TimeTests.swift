//
//  TimeTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 30/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class TimeTests: XCTestCase {
    
    // MARK: - Initialisation
    
    func test_TimeInitialisation() {
        
        let time = Time(value: 2, division: 4)
        XCTAssertEqual(time.value, 2)
        XCTAssertEqual(time.division, 4)
    }
    
    func test_TimeInitialisationWithCrotchets() {
        
        let time = Time(crotchets: 5)
        XCTAssertEqual(time.value, 5)
        XCTAssertEqual(time.division, 4)
    }
    
    func test_TimeInitialisationWithQuavers() {
        
        let time = Time(quavers: 5)
        XCTAssertEqual(time.value, 5)
        XCTAssertEqual(time.division, 8)
    }
    
    func test_TimeInitialisationWithSemiquavers() {
        
        let time = Time(semiquavers: 5)
        XCTAssertEqual(time.value, 5)
        XCTAssertEqual(time.division, 16)
    }
    
    // MARK: - Converted Truncating
    
    func test_ConvertedTruncating() {
        
        XCTAssertEqual(Time(crotchets: 2).convertedTruncating(toDivision: 8), Time(quavers: 4))
        XCTAssertEqual(Time(quavers: 3).convertedTruncating(toDivision: 4), Time(quavers: 2))
        
        XCTAssertEqual(Time(quavers: 0).convertedTruncating(toDivision: 4).value, 0)
        XCTAssertEqual(Time(quavers: 1).convertedTruncating(toDivision: 4).value, 0)
        XCTAssertEqual(Time(quavers: 2).convertedTruncating(toDivision: 4).value, 1)
        XCTAssertEqual(Time(quavers: 3).convertedTruncating(toDivision: 4).value, 1)
        XCTAssertEqual(Time(quavers: 4).convertedTruncating(toDivision: 4).value, 2)
        XCTAssertEqual(Time(quavers: 5).convertedTruncating(toDivision: 4).value, 2)
        XCTAssertEqual(Time(quavers: 6).convertedTruncating(toDivision: 4).value, 3)
        XCTAssertEqual(Time(quavers: 7).convertedTruncating(toDivision: 4).value, 3)
    }
    
    // MARK: - Bar pct
    
    func test_BarPct() {
        
        XCTAssertEqual(Time(crotchets: 0).barPct, 0)
        XCTAssertEqual(Time(crotchets: 1).barPct, 0.25)
        XCTAssertEqual(Time(crotchets: 2).barPct, 0.50)
        XCTAssertEqual(Time(crotchets: 3).barPct, 0.75)
        XCTAssertEqual(Time(crotchets: 4).barPct, 1)
        
        XCTAssertEqual(Time(quavers: 0).barPct, 0)
        XCTAssertEqual(Time(quavers: 1).barPct, 0.125)
        XCTAssertEqual(Time(quavers: 2).barPct, 0.25)
        XCTAssertEqual(Time(quavers: 3).barPct, 0.375)
        XCTAssertEqual(Time(quavers: 4).barPct, 0.5)
        XCTAssertEqual(Time(quavers: 5).barPct, 0.625)
        XCTAssertEqual(Time(quavers: 6).barPct, 0.75)
        XCTAssertEqual(Time(quavers: 7).barPct, 0.875)
        XCTAssertEqual(Time(quavers: 8).barPct, 1)
    }
    
    // MARK: - Equatable

    func test_Equatable() {
        
        XCTAssertEqual(Time(crotchets: 4), Time(crotchets: 4))
        XCTAssertNotEqual(Time(crotchets: 4), Time(crotchets: 3))
        
        XCTAssertEqual(Time(quavers: 4), Time(quavers: 4))
        XCTAssertNotEqual(Time(quavers: 4), Time(quavers: 3))

        XCTAssertEqual(Time(crotchets: 4), Time(quavers: 8))
        XCTAssertEqual(Time(crotchets: 4), Time(semiquavers: 16))
        XCTAssertEqual(Time(quavers: 3), Time(semiquavers: 6))
        XCTAssertNotEqual(Time(crotchets: 4), Time(quavers: 7))
        XCTAssertNotEqual(Time(crotchets: 4), Time(quavers: 9))
    }
    
    // MARK: - Comparable
    
    func test_Comparable() {
        
        XCTAssertTrue(Time(crotchets: 3) < Time(crotchets: 4))
        XCTAssertTrue(Time(semiquavers: 15) < Time(crotchets: 4))
        XCTAssertTrue(Time(semiquavers: 17) > Time(crotchets: 4))
    }
    
    // MARK: - Time / Time Math operators
    
    func test_Addition() {
        
        XCTAssertEqual(Time(crotchets: 2) + Time(crotchets: 2), Time(crotchets: 4))
        XCTAssertEqual(Time(crotchets: 2) + Time(crotchets: 2), Time(crotchets: 4))
        XCTAssertEqual(Time(crotchets: 1) + Time(quavers: 1), Time(quavers: 3))

        XCTAssertNotEqual(Time(crotchets: 1) + Time(crotchets: 1), Time(crotchets: 3))
    }
    
    func test_AdditionInPlace() {
        
        var time = Time(crotchets: 2)
        time += Time(crotchets: 1)
        XCTAssertEqual(time, Time(crotchets: 3))
    }
    
    func test_Subtraction() {
        XCTAssertEqual(Time(crotchets: 3) - Time(crotchets: 1), Time(crotchets: 2))
        XCTAssertEqual(Time(crotchets: 3) - Time(quavers: 1), Time(quavers: 5))
        
        XCTAssertNotEqual(Time(crotchets: 4) - Time(crotchets: 1), Time(quavers: 1))
    }
    
    // MARK: - Time / Int Math operators
    
    func test_MultiplicationWithInt() {
        XCTAssertEqual(Time(crotchets: 2) * 1, Time(crotchets: 2))
        XCTAssertEqual(Time(crotchets: 2) * 2, Time(crotchets: 4))
        XCTAssertEqual(Time(crotchets: 2) * 3, Time(crotchets: 6))
        XCTAssertEqual(Time(crotchets: 2) * 4, Time(crotchets: 8))
    }

}
