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

    convenience init<T>(state: PropertyRef<[String: Any]>, ref: PropertyRef<T>) where T: StringRepresentable {

        self.init(state: state,
                  get: { ref.value },
                  set: {  ref.value = $0 },
                  stateKey: "text")
    }

    convenience init<T, F>(state: PropertyRef<[String: Any]>, ref: PropertyRef<T>, fieldPath: WritableKeyPath<T, F>) where F: StringRepresentable {

        self.init(state: state,
                  get: { ref.value[keyPath: fieldPath] },
                  set: {  ref.value[keyPath: fieldPath] = $0 },
                  stateKey: "text\(fieldPath.hashValue)")
    }

    init<F>(state: PropertyRef<[String: Any]>,
            get: @escaping () -> F,
            set: @escaping (F) -> Void,
            stateKey: String) where F: StringRepresentable {

        let textKey = stateKey //"text\(fieldPath.hashValue)"
        var editText: String? {
            get { state.value[string: textKey] ?? String("\(get())") }
            set { state.value[textKey] = newValue }
        }

        _commit = {
            if let text = editText, let value = F(stringRepresentation: text) {
                set(value)
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
