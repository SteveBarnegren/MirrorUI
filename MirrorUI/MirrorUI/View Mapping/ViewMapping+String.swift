//
//  ViewMapping+String.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 28/02/2021.
//

import Foundation
import SwiftUI

extension ViewMapping {

    static let string: ViewMapping = {
        let mapping = ViewMapping(for: String.self) { ref, context in

            var partial: String {
                get { context.state.value["text"] as? String ?? ref.value }
                set { context.state.value["text"] = newValue }
            }

            let binding = Binding(get: { partial },
                                  set: { partial = $0 })

            let view = HStack {
                Text("\(context.propertyName):")
                TextField(context.propertyName, text: binding, onCommit: {
                    ref.value = partial
                    context.state.value["text"] = nil
                })
            }

            return AnyView(view)
        }
        return mapping
    }()
}
