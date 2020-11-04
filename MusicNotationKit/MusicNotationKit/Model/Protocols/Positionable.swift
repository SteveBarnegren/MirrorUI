//
//  Positionable.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 07/01/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol HorizontallyPositionable {
    var xPosition: Double { get set }
}

protocol VerticallyPositionable {
    var yPosition: Double { get set }
}

protocol Positionable: HorizontallyPositionable, VerticallyPositionable {
    var position: Vector2D { get set }
}

extension Positionable {
    
    var xPosition: Double {
        get {
            return position.x
        }
        set {
            position.x = newValue
        }
    }
    
    var yPosition: Double {
        get {
            return position.y
        }
        set {
            position.y = newValue
        }
    }
}
