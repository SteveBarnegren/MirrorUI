//
//  Playable.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 10/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol Playable: HorizontalLayoutItem {
    var value: NoteValue { get set }
    var time: Time { get set }
    var compositionTime: CompositionTime { get set }
}

extension Playable {
    var duration: Time {
        return value.duration
    }
}
