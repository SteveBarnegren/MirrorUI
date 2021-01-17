//
//  ViewMapper.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation
import SwiftUI

class ViewMapper {

    private var mappings: [ViewMapping]
    
    init() {
        self.mappings = []
    }
    
    init(mappings: [ViewMapping]) {
        self.mappings = mappings
    }
    
    func add(mapping: ViewMapping) {
        mappings.append(mapping)
    }
    
    func canCreateView(forObject object: AnyObject) -> Bool {
        for mapping in mappings {
            if mapping.canCreateView(forObject: object) {
                return true
            }
        }
        return false
    }
    
    func createView(object: AnyObject, context: ViewMappingContext) -> AnyView? {
        
        for mapping in mappings {
            if let view = mapping.createView(object: object, context: context) {
                return view
            }
        }
        return nil
    }
}

struct ViewMappingContext {
    var propertyName: String
    var properties: ControlProperties
    var state: Ref<[String: Any]>
}

class ViewMapping {
    
    private var viewCreator: (AnyObject, ViewMappingContext) -> AnyView?
    private var canCreate: (AnyObject) -> Bool

    
    init<T>(for: T.Type, makeView: @escaping (Ref<T>, ViewMappingContext) -> AnyView) {
        viewCreator = { input, context in
            guard let ref = input as? Ref<T> else {
                return nil
            }
            
            return makeView(ref, context)
        }
        
        canCreate = { input in
            return input is Ref<T>
        }
    }
    
    func canCreateView(forObject object: AnyObject) -> Bool {
        return canCreate(object)
    }
    
    func createView(object: AnyObject, context: ViewMappingContext) -> AnyView? {
        return viewCreator(object, context)
    }
}

extension ViewMapper {
    
    static let defaultMapper = ViewMapper(mappings: [
        
        // BinaryFloatingPoint types
        ViewMapping.bool,
        ViewMapping.double,
        // FixedWidthInteger types
        ViewMapping.int,
        ViewMapping.int16,
        ViewMapping.int32,
        ViewMapping.int64,
        ViewMapping.int8,
        ViewMapping.uInt,
        ViewMapping.uInt16,
        ViewMapping.uInt32,
        ViewMapping.uInt64,
        ViewMapping.uInt8,
    ])
    
}
