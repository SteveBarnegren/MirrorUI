//
//  ViewMapping+Color.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 23/02/2021.
//

import Foundation
import SwiftUI

extension ViewMapping {

    static let color: ViewMapping = {
        let mapping = ViewMapping(for: Color.self) { ref, context in

            let binding = Binding(get: { ref.value },
                                  set: { ref.value = $0 })

            let picker = ColorPicker(context.propertyName, selection: binding)
            return AnyView(picker)
        }
        return mapping
    }()
}
