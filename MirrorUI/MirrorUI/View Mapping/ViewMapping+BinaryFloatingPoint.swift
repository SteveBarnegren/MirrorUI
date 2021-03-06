//
//  ViewMapping+Double.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation
import SwiftUI

extension Double: StringRepresentable {
    init?(stringRepresentation: String) {
        self.init(stringRepresentation)
    }
}

extension Float: StringRepresentable {
    init?(stringRepresentation: String) {
        self.init(stringRepresentation)
    }
}

extension ViewMapping {
    
    static let double: ViewMapping = {
        return makeFloatingPointMapping(forType: Double.self, stringInit: Double.init)
    }()
    
    static let float: ViewMapping = {
        return makeFloatingPointMapping(forType: Float.self, stringInit: Float.init)
    }()

    static let cgFloat: ViewMapping = {
        return makeFloatingPointMapping(forType: CGFloat.self, stringInit: CGFloat.init)
    }()
    
    static func makeFloatingPointMapping<T: BinaryFloatingPoint>(forType: T.Type, stringInit: @escaping (String) -> T?)
    -> ViewMapping where T.Stride: BinaryFloatingPoint, T: StringRepresentable {
        
        return ViewMapping(for: T.self) { ref, context in
                        
            let state = context.state
            let properties = context.properties

            let numericBinding = Binding(get: { ref.value },
                                         set: { ref.value = $0 })

            let binder = NumericEntryBinder(state: state, ref: ref)
            
            // Create ranged or non-ranged view
            if let range: ClosedRange<T> = properties.getRange() {
               return makeRangedFloatingPointView(context: context,
                                                  numericBinding: numericBinding,
                                                  textBinder: binder,
                                                  range: range).asAnyView()
            } else {
                return makeFloatingPointView(context: context,
                                             binder: binder).asAnyView()
                
            }
        }
    }
   
}

fileprivate func makeFloatingPointView(context: ViewMappingContext,
                                       binder: NumericEntryBinder) -> some View {
    
    return HStack {
        Text(context.propertyName)
        TextField("Value", text: binder.textBinding, onCommit: { binder.commit() })
    }
}

fileprivate func makeRangedFloatingPointView<T: BinaryFloatingPoint>(context: ViewMappingContext,
                                                                     numericBinding: Binding<T>,
                                                                     textBinder: NumericEntryBinder,
                                                                     range: ClosedRange<T>) -> some View where T.Stride: BinaryFloatingPoint {
    
    // State accessors
    let state = context.state
    var editing: Bool {
        get { state.value[bool: "editing"] ?? false }
        set { state.value["editing"] = newValue }
    }
    
    let stack = VStack(alignment: .leading) {
        Text(context.propertyName)
        HStack {
            Slider(value: numericBinding, in: range)
            Button() {
                editing = !editing
            } label: {
                Image(systemName: "pencil")
            }
        }
        if editing {
            HStack {
                TextField("Value", text: textBinder.textBinding, onCommit: { textBinder.commit() })
                Spacer()
            }
        }
    }
    
    return stack
}
