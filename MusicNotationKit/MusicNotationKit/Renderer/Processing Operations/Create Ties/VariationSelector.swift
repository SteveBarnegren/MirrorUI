//
//  VariationSelector.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/05/2020.
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

class VariationSelector<T> {
    
    func pruneVariations(variationSets: [VariationSet<T>], areCompatable: (T, T) -> Bool) {
        
        let sets = variationSets
        
        var sequencer = VariationSequencer(variationSets: sets)
    
        var iteration: [T]?
        repeat {
            iteration = sequencer.next()
        } while iteration.flatMap({ containsConflicts($0, areCompatable) }) == true

        for (chosenIndex, set) in zip(sequencer.variationIndexes, sets) {
            set.prune(toIndex: chosenIndex)
        }
    }
    
    private func containsConflicts(_ values: [T], _ areCompatable: (T, T) -> Bool) -> Bool {
        return values.allPairs().contains { pair in
            areCompatable(pair.0, pair.1) == false
        }
    }
}

struct VariationSequencer<T> {
    
    private let variationSets: [VariationSet<T>]
    private(set) var variationIndexes: [Int]
    private var hasReturnedInitialValues = false
    
    init(variationSets: [VariationSet<T>]) {
        self.variationSets = variationSets
        self.variationIndexes = [Int](repeating: 0, count: variationSets.count)
    }
    
    mutating func next() -> [T]? {
        
        if hasReturnedInitialValues == false {
            hasReturnedInitialValues = true
            return currentValues()
        }
        
        var changedSetIndex: Int?
        var suitabilityLevel = VariationSuitability.lowest
        
        for (setIndex, (variationIndex, set)) in zip(variationIndexes, variationSets).enumerated() {
            guard let variation = set.variations[maybe: variationIndex+1] else {
                continue
            }
            
            if changedSetIndex == nil || variation.suitability > suitabilityLevel {
                changedSetIndex = setIndex
                suitabilityLevel = variation.suitability
            }
        }
        
        if let setIndex = changedSetIndex {
            variationIndexes[setIndex] += 1
            return currentValues()
        } else {
            return nil
        }
    }
    
    func currentValues() -> [T] {
        return currentVariations().map { $0.value }
    }
    
    func currentVariations() -> [Variation<T>] {
        return zip(variationIndexes, variationSets).map { index, set in
            set.variations[index]
        }
    }
    
}
