//
//  VariationSelector.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 08/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class AnyVariationSet {
    
    private let _valueAtIndex: (Int) -> Any
    private let _getValues: () -> [Any]
    private let _getSuitabilities: () -> [VariationSuitability]
    private let _pruneToIndex: (Int) -> Void
    
    var values: [Any] {
        return _getValues()
    }
    
    var suitabilities: [VariationSuitability] {
        return _getSuitabilities()
    }
    
    init<T>(_ variationSet: VariationSet<T>) {
        self._valueAtIndex = { return variationSet.variations[$0].value }
        self._getValues = { return variationSet.variations.map { $0.value } as [Any] }
        self._getSuitabilities = { return variationSet.variations.map { $0.suitability } }
        self._pruneToIndex = { variationSet.prune(toIndex: $0) }
    }
    
    func value(at index: Int) -> Any {
        return self._valueAtIndex(index)
    }
    
    func prune(to index: Int) {
        self._pruneToIndex(index)
    }
}

class VariationSelectorSet {
    var variationSet: AnyVariationSet
    var selectedIndex = 0

    init(_ variationSet: AnyVariationSet) {
        self.variationSet = variationSet
    }
    
    var currentValue: Any {
        return variationSet.value(at: selectedIndex)
    }
    
    var nextVariationValue: Any? {
        return variationSet.values[maybe: selectedIndex+1]
    }
    
    var nextVariationSuitability: VariationSuitability? {
        return variationSet.suitabilities[maybe: selectedIndex+1]
    }
    
    func prune() {
        variationSet.prune(to: selectedIndex)
    }
}

class ConflictIdentifier<T, U> {
    
    private var areCompatible: (T, U) -> Bool
    
    init(areCompatible: @escaping (T, U) -> Bool) {
        self.areCompatible = areCompatible
    }
    
    func isConflict(first: T, second: U) -> Bool {
        return areCompatible(first, second) == false
    }
}

class AnyConflictIdentifier {
    
    private var _isConflict: (Any, Any) -> Bool
    
    init<T, U>(_ conflictIdentifier: ConflictIdentifier<T, U>) {
        self._isConflict = { first, second in
            if let f = first as? T, let s = second as? U {
                return conflictIdentifier.isConflict(first: f, second: s)
            } else if let f = second as? T, let s = first as? U {
                return conflictIdentifier.isConflict(first: f, second: s)
            } else {
                return false
            }
        }
    }
    
    func isConflict(first: Any, second: Any) -> Bool {
        return _isConflict(first, second)
    }
}

class VariationSelector {
    
    private var conflictIdentifiers = [AnyConflictIdentifier]()
    private var variationSets = [VariationSelectorSet]()
    
    func add<T, U>(conflictIdentifier: ConflictIdentifier<T, U>) {
        conflictIdentifiers.append(AnyConflictIdentifier(conflictIdentifier))
    }
    
    func add<T>(variationSet: VariationSet<T>) {
        variationSets.append(VariationSelectorSet(AnyVariationSet(variationSet)))
    }
    
    func add<T>(variationSets: [VariationSet<T>]) {
        variationSets.forEach(add)
    }

    func pruneVariations() {
        let sets = variationSets
        var conflictingSets = [VariationSelectorSet]()

        repeat {
            // Figure out if there are any conflicts
            conflictingSets.removeAll()
            sets.allPairs().forEach { first, second in
                if self.areCompatible(first.currentValue, second.currentValue) {
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
    
    private func areCompatible(_ first: Any, _ second: Any) -> Bool {
        for conflictIdentifier in conflictIdentifiers {
            if conflictIdentifier.isConflict(first: first, second: second) {
                return false
            }
        }
        return true
    }
    
    private func moveIndex(inSets sets: [VariationSelectorSet]) -> Bool {
        
        // Find the set to change
        var variationSetToChange: VariationSelectorSet?
        var currentSuitability = VariationSuitability.lowest
        
        for set in sets {
            guard let nextSuitability = set.nextVariationSuitability else {
                continue
            }
            
            if variationSetToChange == nil || nextSuitability > currentSuitability {
                variationSetToChange = set
                currentSuitability = nextSuitability
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
