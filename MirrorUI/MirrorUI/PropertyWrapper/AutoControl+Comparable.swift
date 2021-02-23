//
//  AutoControl+Comparable.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 21/02/2021.
//

import Foundation

extension MirrorUI where T: Comparable {

    public var min: T? {
        set {
            properties.set(min: newValue)
            updateMinMaxValueModifier()
        }
        get { properties.getMin() }
    }

    public var max: T? {
        set {
            properties.set(max: newValue)
            updateMinMaxValueModifier()
        }
        get { properties.getMax() }
    }

    public init(wrappedValue: T, min: T? = nil, max: T? = nil) {
        self.init(wrappedValue: wrappedValue)
        self.min = min
        self.max = max
    }

    mutating private func updateMinMaxValueModifier() {

        let minValue = self.min
        let maxValue = self.max

        ref.set(valueModifier: { value in
            var result = value
            if let minValue = minValue {
                result = Swift.max(minValue, result)
            }
            if let maxValue = maxValue {
                result = Swift.min(maxValue, result)
            }
            return result

        }, forKey: "MinMax")
    }

}

extension ControlProperties {

    mutating func set<T>(min: T?) {
        storage["min"] = min
    }

    func getMin<T>() -> T? {
        storage["min"] as? T
    }

    mutating func set<T>(max: T?) {
        storage["max"] = max
    }

    func getMax<T>() -> T? {
        storage["max"] as? T
    }
}
