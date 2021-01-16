//
//  Ref.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 16/01/2021.
//

import Foundation

public class Ref<T>: InternalDidSetCaller {
    public var didSet: (T) -> Void = { _ in }
    var internalDidSet: () -> Void = {}
    
    var value: T {
        didSet {
            internalDidSet()
            didSet(value)
        }
    }
    init(value: T) {
        self.value = value
    }
}

protocol InternalDidSetCaller: class {
    var internalDidSet: () -> Void { get set }
}
