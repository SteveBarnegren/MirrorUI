//
//  ViewMapping+Bool.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation
import SwiftUI

extension ViewMapping {
    
    static let bool: ViewMapping = {
        let mapping = ViewMapping(for: Bool.self) { ref, context in
           
            let binding = Binding(get: { ref.value },
                                  set: { ref.value = $0 })
            
            let toggle = Toggle(context.propertyName, isOn: binding)
            return AnyView(toggle)
        }
        mapping.displaysTitle = true
        return mapping
    }()
}
