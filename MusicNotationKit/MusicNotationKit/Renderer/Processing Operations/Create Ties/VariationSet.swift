//
//  VariationSet.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 13/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

enum VariationSuitability: Int, CaseIterable {
    case concession
    case allowed
    case preferable
    
    static let lowest: VariationSuitability = {
        return VariationSuitability.allCases.min()!
    }()
}

extension VariationSuitability: Comparable {
    static func < (lhs: VariationSuitability, rhs: VariationSuitability) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

class Variation<T> {
    let value: T
    var suitability: VariationSuitability
    
    init(value: T, suitability: VariationSuitability = .allowed) {
        self.value = value
        self.suitability = suitability
    }
}

class VariationSet<T> {
    var variations: [Variation<T>]
    
    var chosenVariation: T {
        return variations.first!.value
    }
    
    init(variations: [Variation<T>]) {
        self.variations = variations
    }
    
    func prune(toIndex index: Int) {
        variations = variations.suffix(from: index).toArray()
    }
}
