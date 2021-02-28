//
//  ViewMapper.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation
import SwiftUI

public class ViewMapper {

    private var mappings: [ViewMapping]
    
    init() {
        self.mappings = []
    }
    
    init(mappings: [ViewMapping]) {
        self.mappings = mappings
    }
    
    public func add(mapping: ViewMapping) {
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
    
    func createView(object: PropertyRefCastable, context: ViewMappingContext) -> AnyView? {
        
        for mapping in mappings {
            if let view = mapping.createView(object: object, context: context) {
                return view
            }
        }
        return nil
    }
}

public struct ViewMappingContext {
    public var propertyName: String
    public var properties: ControlProperties
    public var state: Ref<[String: Any]>
}

public class ViewMapping {
    
    private var viewCreator: (PropertyRefCastable, ViewMappingContext) -> AnyView?
    private var canCreate: (AnyObject) -> Bool

    public init<T>(for: T.Type, makeView: @escaping (PropertyRef<T>, ViewMappingContext) -> AnyView) {
        viewCreator = { input, context in

            guard let ref = input.maybeCast(to: T.self) else {
                return nil
            }
            
            return makeView(ref, context)
        }
        
        canCreate = { input in
            return input is PropertyRef<T>
        }
    }
    
    func canCreateView(forObject object: AnyObject) -> Bool {
        return canCreate(object)
    }
    
    func createView(object: PropertyRefCastable, context: ViewMappingContext) -> AnyView? {
        return viewCreator(object, context)
    }
}

extension ViewMapper {


    
    public static let defaultMapper = { () -> ViewMapper in

        var mappings = [
            ViewMapping.rectLike,
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
            // SwiftUI types
            ViewMapping.color,
            // CoreGraphics types
            ViewMapping.cgFloat,
            ViewMapping.cgPoint,
            ViewMapping.cgSize,
        ]

        #if os(macOS)
        mappings += [
            ViewMapping.nsPoint,
            ViewMapping.nsSize
        ]
        #endif

        return ViewMapper(mappings: mappings)
    }()
    
}
