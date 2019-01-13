//
//  HorizontalConstraintTests.swift
//  MusicNotationKitTests
//
//  Created by Steve Barnegren on 12/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class ConstraintPrirityTests: XCTestCase {
    
    func test_Equatable() {
        
        XCTAssertTrue(ConstraintPriority.regular < ConstraintPriority.required)
        XCTAssertEqual(ConstraintPriority.regular, ConstraintPriority.regular)
    }
    
}

class HorizontalConstraintTests: XCTestCase {

   // MARK: - Minimum distance at priority
    
    func test_WhenTwoPrioritiesArePresent_DistanceAtLowerPriorityUsesLowerPriority () {
        
        let regular = ConstraintValue(length: 10, priority: .regular)
        let required = ConstraintValue(length: 5, priority: .required)
        let constraint = HorizontalConstraint(values: [regular, required])
        
        XCTAssertEqual(constraint.minimumDistance(atPriority: .regular), 10)
    }
    
    func test_WhenTwoPrioritiesArePresent_DistanceAtHigherPriorityUsesHigherPriority () {
        
        let regular = ConstraintValue(length: 10, priority: .regular)
        let required = ConstraintValue(length: 5, priority: .required)
        let constraint = HorizontalConstraint(values: [regular, required])
        
        XCTAssertEqual(constraint.minimumDistance(atPriority: .required), 5)
    }

}
