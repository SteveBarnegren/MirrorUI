//
//  Array+Path.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 16/03/2021.
//  Copyright © 2021 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array where Element == Path {
    
    var minY: Double {
        return self.map { $0.minY }.min() ?? 0
    }
    
    var maxY: Double {
        return self.map { $0.maxY }.max() ?? 0
    }
}
