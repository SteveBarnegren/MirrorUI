//
//  ControlProperties.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 11/01/2021.
//

import Foundation

public struct ControlProperties {
    
    var storage = [String: Any]()
    
    // Range
    mutating func set<T>(range: ClosedRange<T>?) {
        storage["range"] = range
    }
    func getRange<T>() -> ClosedRange<T>? {
        storage["range"] as? ClosedRange<T>
    }
}
