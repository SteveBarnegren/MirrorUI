//
//  Optional+Extensions.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 30/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Numeric {
    
    func orZero() -> Wrapped {
        return self ?? 0
    }
}
