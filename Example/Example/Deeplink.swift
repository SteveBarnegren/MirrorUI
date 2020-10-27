//
//  Deeplink.swift
//  Example
//
//  Created by Steve Barnegren on 22/03/2020.
//  Copyright © 2020 Steve Barnegren. All rights reserved.
//

import Foundation

class Deeplink {
    
    private var components: [String]
    
    init(path: String) {
        components = path.components(separatedBy: "/")
    }
    
    func nextPathComponent() -> String? {
        if components.isEmpty {
            return nil
        } else {
            return components.removeFirst()
        }
    }
}
