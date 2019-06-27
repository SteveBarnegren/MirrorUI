//
//  Sequence+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 27/06/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

extension Sequence {
    
    func toAnySequence() -> AnySequence<Element> {
        return AnySequence(self)
    }
}
