//
//  Ref.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 25/02/2021.
//

import Foundation

class Ref<T> {

    var value: T {
        didSet {
            didSet(value)
        }
    }

    var didSet: (T) -> Void = { _ in }

    init(value: T) {
        self.value = value
    }
}
