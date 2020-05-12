//
//  Sequence+UnnestTuples.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 29/09/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Sequence {

    // ((T, U), V) -> (T, U, V)
    func unnestTuples<T, U, V>() -> UnnestedTuplesSequence<Self, Self.Element, (T, U, V)> where Element == ((T, U), V) {
        return UnnestedTuplesSequence(sequence: self) { arg in
            return (arg.0.0, arg.0.1, arg.1)
        }
    }
    
    // (T, (U, V)) -> (T, U, V)
    func unnestTuples<T, U, V>() -> UnnestedTuplesSequence<Self, Self.Element, (T, U, V)> where Element == (T, (U, V)) {
        return UnnestedTuplesSequence(sequence: self) { arg in
            return (arg.0, arg.1.0, arg.1.1)
        }
    }
}

struct UnnestedTuplesSequence<WrappedSequence: Sequence, Input, Output>: Sequence, IteratorProtocol where WrappedSequence.Element == Input {
  
    typealias Element = Output
    
    private let transform: (Input) -> Output
    private let wrappedSequence: WrappedSequence
    private var wrappedIterator: WrappedSequence.Iterator
    
    init(sequence: WrappedSequence, transform: @escaping (Input) -> Output) {
        self.transform = transform
        self.wrappedSequence = sequence
        self.wrappedIterator = sequence.makeIterator()
    }
    
    mutating func next() -> Output? {
        if let v = wrappedIterator.next() {
            return transform(v)
        } else {
            return nil
        }
    }
}
