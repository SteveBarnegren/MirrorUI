//
//  ViewMapping+Double.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation
import SwiftUI

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
    -> ViewMapping where T.Stride: BinaryFloatingPoint {
        
        return ViewMapping(for: T.self) { ref, context in
                        
            let state = context.state
            let properties = context.properties
            
            var editText: String? {
                get { state.value[string: "text"] ?? String("\(ref.value)") }
                set { state.value["text"] = newValue }
            }
            
            // Make bindings
            let numericBinding = Binding(get: { ref.value },
                                         set: { ref.value = $0 })
            let textBinding = Binding(get: { editText ?? "" },
                                      set: { editText = $0 })
            
            func commitEditText() {
                if let text = editText, let value = stringInit(text) {
                    ref.value = value
                }
                editText = nil
            }
            
            // Create ranged or non-ranged view
            if let range: ClosedRange<T> = properties.getRange() {
               return makeRangedFloatingPointView(context: context,
                                                  numericBinding: numericBinding,
                                                  textBinding: textBinding,
                                                  range: range,
                                                  commitEditText: commitEditText).asAnyView()
            } else {
                return makeFloatingPointView(context: context,
                                             textBinding: textBinding,
                                             commitEditText: commitEditText).asAnyView()
                
            }
        }
    }
    
   
}

fileprivate func makeFloatingPointView(context: ViewMappingContext,
                                       textBinding: Binding<String>,
                                       commitEditText: @escaping () -> Void) -> some View {
    
    return HStack {
        Text(context.propertyName)
        TextField("Value", text: textBinding, onCommit: { commitEditText() })
    }
}

fileprivate func makeRangedFloatingPointView<T: BinaryFloatingPoint>(context: ViewMappingContext,
                                                                     numericBinding: Binding<T>,
                                                                     textBinding: Binding<String>,
                                                                     range: ClosedRange<T>,
                                                                     commitEditText: @escaping () -> Void) -> some View where T.Stride: BinaryFloatingPoint {
    
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
                TextField("Value", text: textBinding, onCommit: { commitEditText() })
                Spacer()
            }
        }
    }
    
    return stack
}
