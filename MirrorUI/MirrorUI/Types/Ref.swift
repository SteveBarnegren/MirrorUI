//
//  Ref.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 16/01/2021.
//

import Foundation


class Ref<T>: InternalDidSetCaller {
    var didSet: (T) -> Void = { _ in }
    var internalDidSet: () -> Void = {}
    private var valueModifiers = [String: (T) -> T]()

    var value: T {
        didSet {
            value = modify(value: value)
            internalDidSet()
            didSet(value)
        }
    }
    init(value: T) {
        self.value = value
    }

    func set(valueModifier: @escaping (T) -> T, forKey key: String) {
        valueModifiers[key] = valueModifier
    }

    private func modify(value: T) -> T {

        var modified = value
        for modifier in valueModifiers.values {
            modified = modifier(modified)
        }
        return modified
    }
}

protocol InternalDidSetCaller: class {
    var internalDidSet: () -> Void { get set }
}
