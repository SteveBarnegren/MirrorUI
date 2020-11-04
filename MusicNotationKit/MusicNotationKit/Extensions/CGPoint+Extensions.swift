//
//  CGPoint+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    init(_ point: Vector2D) {
        self.init(x: point.x, y: point.y)
    }
}
