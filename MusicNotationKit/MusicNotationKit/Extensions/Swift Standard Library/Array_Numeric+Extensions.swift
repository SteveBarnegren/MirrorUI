//
//  Array+NumericExtensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 21/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

extension Array where Element: Numeric {
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
}
