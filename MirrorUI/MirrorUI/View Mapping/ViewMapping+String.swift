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
            return AnyView(StringEditView(ref: ref, context: context))
        }
        return mapping
    }()
}

private struct StringEditView: View {

    private let ref: PropertyRef<String>
    private let context: ViewMappingContext
    @State private var text: String

    init(ref: PropertyRef<String>, context: ViewMappingContext) {
        self.ref = ref
        self.context = context
        self.text = ref.value
    }

    @ViewBuilder
    var body: some View {
        Text("\(context.propertyName):")
        TextField(context.propertyName, text: $text, onCommit: {
            ref.value = text
        })
    }
}
