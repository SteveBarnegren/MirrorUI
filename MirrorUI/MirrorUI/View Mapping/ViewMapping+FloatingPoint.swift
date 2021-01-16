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
    
    static func makeFloatingPointMapping<T: BinaryFloatingPoint>(forType: T.Type, stringInit: @escaping (String) -> T?)
    -> ViewMapping where T.Stride: BinaryFloatingPoint {
        
        return ViewMapping(for: T.self) { ref, context in
                        
            let state = context.state
            let properties = context.properties
            
            // State accessors
            var editing: Bool {
                get { state.value[bool: "editing"] ?? false }
                set { state.value["editing"] = newValue }
            }
            
            var editText: String? {
                get { state.value[string: "text"] ?? String("\(ref.value)") }
                set { state.value["text"] = newValue }
            }
            
            // Make bindings
            let sliderBinding = Binding(get: { ref.value },
                                        set: { ref.value = $0 })
           /* let textBinding = Binding(get: { String("\(ref.value)") },
                                      set: {
                                        if let value = stringInit($0) {
                                            ref.value = value
                                        }
                                      })*/
            let textBinding = Binding(get: { editText ?? "" },
                                      set: { editText = $0 })
            
            func commitEditText() {
                if let text = editText, let value = stringInit(text) {
                    ref.value = value
                }
                editText = nil
            }
            
            let sliderView: AnyView
            if let range: ClosedRange<T> = properties.getRange() {
                let slider = Slider(value: sliderBinding, in: range)
                sliderView = AnyView(slider)
            } else {
                let slider = Slider(value: sliderBinding)
                sliderView = AnyView(slider)
            }
            
            let stack = VStack {
                HStack {
                    sliderView
                    
                    Button() {
                        editing = !editing
                    } label: {
                        /*Image(systemName: "square.and.pencil") macos 11 only */
                        Text("Edit")
                    }
                }
                if editing {
                    HStack {
                        TextField("Value", text: textBinding, onCommit: { commitEditText() })
                        Spacer()
                    }
                }
            }
            
            return AnyView(stack)
        }
    }
}


