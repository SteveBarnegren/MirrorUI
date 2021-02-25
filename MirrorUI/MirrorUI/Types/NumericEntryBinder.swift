//
//  NumericEntryBinder.swift
//  MirrorUI
//
//  Created by Steve Barnegren on 25/02/2021.
//

import Foundation
import SwiftUI

/// Creates a text binding to a numeric field.
class NumericEntryBinder {

    let textBinding: Binding<String>

    private let _commit: () -> Void

    init<T, F>(state: PropertyRef<[String: Any]>, ref: PropertyRef<T>, fieldPath: WritableKeyPath<T, F>) where F: StringRepresentable {

        let textKey = "text\(fieldPath.hashValue)"
        var editText: String? {
            get { state.value[string: textKey] ?? String("\(ref.value[keyPath: fieldPath])") }
            set { state.value[textKey] = newValue }
        }

        _commit = {
            if let text = editText, let value = F(stringRepresentation: text) {
                ref.value[keyPath: fieldPath] = value
            }
            editText = nil
        }

        textBinding = Binding(get: { editText ?? "" },
                              set: { editText = $0 })
    }

    func commit() {
        _commit()
    }
}
