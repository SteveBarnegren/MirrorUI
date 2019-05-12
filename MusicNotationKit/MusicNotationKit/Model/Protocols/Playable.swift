//
//  Playable.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol Playable: Positionable, HorizontallyConstrained {
    var value: NoteValue { get }
    var time: Time { get set }
    var horizontallyConstrainedItems: [HorizontallyConstrained] { get }
}

extension Playable {
    var duration: Time {
        return value.duration
    }
}
