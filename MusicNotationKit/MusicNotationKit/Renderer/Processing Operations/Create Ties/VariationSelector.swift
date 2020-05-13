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

class VariationSelectorSet<T> {
    let variationSet: VariationSet<T>
    var selectedIndex = 0
    var hasFurtherVariations: Bool {
        return selectedIndex < variationSet.variations.endIndex-1
    }
    
    var currentValue: T {
        return variationSet.variations[selectedIndex].value
    }
    
    var nextVariation: Variation<T>? {
        return variationSet.variations[maybe: selectedIndex+1]
    }
    
    init(variationSet: VariationSet<T>) {
        self.variationSet = variationSet
    }
    
    func prune() {
        variationSet.prune(toIndex: selectedIndex)
    }
}

class VariationSelector<T> {
    
    private let areCompatable: (T, T) -> Bool
    
    init(areCompatable: @escaping (T, T) -> Bool) {
        self.areCompatable = areCompatable
    }
    
    func pruneVariations(variationSets: [VariationSet<T>]) {
        let sets = variationSets.map(VariationSelectorSet.init)
        var conflictingSets = [VariationSelectorSet<T>]()

        repeat {
            // Figure out if there are any conflicts
            conflictingSets.removeAll()
            sets.allPairs().forEach { first, second in
                if areCompatable(first.currentValue, second.currentValue) {
                    return
                }
                
                if !conflictingSets.contains(where: { $0 === first }) {
                    conflictingSets.append(first)
                }
                if !conflictingSets.contains(where: { $0 === second }) {
                    conflictingSets.append(second)
                }
            }
            
            // Resolved if no conflicts
            if conflictingSets.isEmpty {
                sets.forEach { $0.prune() }
                return
            }
        } while moveIndex(inSets: conflictingSets)
        
        sets.forEach { $0.prune() }
    }
    
    private func moveIndex(inSets sets: [VariationSelectorSet<T>]) -> Bool {
        
        // Find the set to change
        var variationSetToChange: VariationSelectorSet<T>?
        var currentSuitability = VariationSuitability.lowest
        
        for set in sets {
            guard let nextVariation = set.nextVariation else {
                continue
            }
            
            if variationSetToChange == nil || nextVariation.suitability > currentSuitability {
                variationSetToChange = set
                currentSuitability = nextVariation.suitability
            }
        }
        
        // Increment the variation
        variationSetToChange?.selectedIndex += 1
        
        // Return whether to continue
        return variationSetToChange != nil
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
