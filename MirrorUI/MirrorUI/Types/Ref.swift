//
//  Ref.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 16/01/2021.
//

import Foundation

public class Ref<T> {
    public var didSet: (T) -> Void = { _ in }
    
    var value: T {
        didSet { didSet(value) }
    }
    init(value: T) {
        self.value = value
    }
}
