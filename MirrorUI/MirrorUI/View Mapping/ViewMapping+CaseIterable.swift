//
//  ViewMapping+CaseIterable.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 12/01/2021.
//

import Foundation
import SwiftUI

protocol CaseIterableRefProvider {
    var caseIterableRef: CaseIterableRef { get }
}

class CaseIterableRef {
    
    struct Case {
        let value: Any
        let name: String
    }
    
    var allCases: [Case]
    private var get: () -> Any
    private var set: (Any) -> Void

    var value: Any {
        get { get() }
        set { set(newValue) }
    }
    
    private var getByIndex: () -> Int
    private var setByIndex: (Int) -> Void
    var valueIndex: Int {
        get { getByIndex() }
        set { setByIndex(newValue) }
    }
    
    var selectedCase: Case {
        return allCases[valueIndex]
    }

    init<T: CaseIterable & Equatable>(_ object: Ref<T>) {
        
        var cases = [Case]()
        
        for c in type(of: object.value).allCases {
            cases.append(
                Case(value: c, name: "\(c)")
            )
        }
        
        allCases = cases
        
        get = {
            return object.value
        }
        
        set = {
            object.value = $0 as! T
        }
        
        getByIndex = {
            for (index, c) in type(of: object.value).allCases.enumerated() {
                if c == object.value {
                    return index
                }
            }
            return 0
        }
        
        setByIndex = {
            let allCases = type(of: object.value).allCases
            let index = allCases.index(allCases.startIndex, offsetBy: $0)
            object.value = type(of: object.value).allCases[index]
        }
    }
}

extension ViewMapping {
    /*
    static func makeCaseIterableView(ref: CaseIterableRef, context: ViewMappingContext) -> AnyView {
        
        let cases = ref.allCases
        
        let view = VStack {
            ForEach(0..<cases.count) { index in
                let aCase = cases[index]
                Text("\(aCase.name)")
            }
        }
        
        return AnyView(view)
    }
    */
    static func makeCaseIterableView(ref: CaseIterableRef, context: ViewMappingContext) -> AnyView {
        
        let cases = ref.allCases
        let reloadTrigger = context.reloadTrigger
       
        let selectionBinding = Binding(get: { ref.valueIndex },
                                       set: {
                                        ref.valueIndex = $0
                                        reloadTrigger.reload()
                                       })
        
        #if os(macOS)
        
        let picker = Picker(selection: selectionBinding, label: Text(context.propertyName)) {
            ForEach(0..<cases.count) { index in
                let aCase = cases[index]
                Text("\(aCase.name)")
            }
        }.pickerStyle(MenuPickerStyle())
        return AnyView(picker)
        
        #else
        
        let picker = Picker(selection: selectionBinding, label: Text(ref.selectedCase.name)) {
            ForEach(0..<cases.count) { index in
                let aCase = cases[index]
                Text("\(aCase.name)")
            }
        }.pickerStyle(MenuPickerStyle())
        
        let pickerAndTitle = HStack {
            Text(context.propertyName)
            picker
        }.animation(.none)
        
        return AnyView(pickerAndTitle)
        
        #endif
    }
}

