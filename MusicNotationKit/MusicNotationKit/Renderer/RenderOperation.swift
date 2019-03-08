//
//  RenderOperation.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 06/03/2019.
//  Copyright © 2019 Steve Barnegren. All rights reserved.
//

import Foundation

protocol RenderOperation {
    func process(composition: Composition, layoutWidth: Double)
}
