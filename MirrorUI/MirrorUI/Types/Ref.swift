//
//  Ref.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 25/02/2021.
//

import Foundation

public class Ref<T> {

    public var value: T {
        didSet {
            didSet(value)
        }
    }

    var didSet: (T) -> Void = { _ in }

    init(value: T) {
        self.value = value
    }
}
