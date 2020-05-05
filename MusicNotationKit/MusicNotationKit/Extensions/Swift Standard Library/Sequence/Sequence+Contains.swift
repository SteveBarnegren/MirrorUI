//
//  Sequence+Contains.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 05/05/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

extension Sequence where Element: Equatable {
    
    func contains<T: Sequence>(anyOf other: T) -> Bool where T.Element == Element {
        return self.contains { (element) -> Bool in
            other.contains(element)
        }
    }
}
