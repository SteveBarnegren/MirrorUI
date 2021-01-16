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
            
            print("MakeFloatView: \(Date())")
            
            let state = context.state
            let properties = context.properties
            
            // State accessors
            var showingPopover: Bool {
                get { state.value[bool: "showEditPopover"] ?? false }
                set { state.value["showEditPopover"] = newValue; print("showEditPopover: \(newValue)") }
            }
            
            // Make bindings
            let sliderBinding = Binding(get: { ref.value },
                                        set: { ref.value = $0 })
            let textBinding = Binding(get: { String("\(ref.value)") },
                                      set: {
                                        if let value = stringInit($0) {
                                            ref.value = value
                                        }
                                      })
            let showingPopoverBinding = Binding(get: { showingPopover },
                                                set: { showingPopover = $0 })
            
            let sliderView: AnyView
            if let range: ClosedRange<T> = properties.getRange() {
                let slider = Slider(value: sliderBinding, in: range, onEditingChanged: { _ in
                    context.reloadTrigger.reload()
                })
                sliderView = AnyView(slider)
            } else {
                let slider = Slider(value: sliderBinding)
                sliderView = AnyView(slider)
            }
            
            let stack = VStack {
                HStack {
                    sliderView
                    
                    Button() {
                        showingPopover = !showingPopover
                    } label: {
                        /*Image(systemName: "square.and.pencil") macos 11 only */
                        Text("Edit")
                    }
                }
                if showingPopover {
                    HStack {
                        TextField("Value", text: textBinding, onEditingChanged: { _ in
                            context.reloadTrigger.reload()
                        }, onCommit: {})
                        Spacer()
                    }
                }
            }
            
            return AnyView(stack)
        }
    }
}


