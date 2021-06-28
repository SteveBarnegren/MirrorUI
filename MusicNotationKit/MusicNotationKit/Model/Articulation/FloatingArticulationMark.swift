//
//  FloatingArticulationMark.swift
//  MusicNotationKit
//
//  Created by Steven Barnegren on 28/06/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

protocol FloatingArticulationMark: AnyObject, VerticallyPositionable {
    var yPosition: Double { get set }
}
