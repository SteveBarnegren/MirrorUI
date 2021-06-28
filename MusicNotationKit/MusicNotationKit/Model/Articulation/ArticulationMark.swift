//
//  ArticulationMark.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 26/10/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

protocol ArticulationMark: AnyObject {
    var stavePosition: StavePosition { get set }
}

