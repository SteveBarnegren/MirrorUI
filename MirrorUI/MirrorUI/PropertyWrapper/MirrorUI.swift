//
//  MirrorUI.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation

/// Protocol that the MirrorUI property wrapper conforms to. This is useful for
/// erasing the generic type of the property wrapper.
protocol MirrorControl {
    var mirrorObject: AnyObject { get }
    var properties: ControlProperties { get }
    var name: String? { get }
}

@propertyWrapper public class MirrorUI<T> {

    public var name: String?

    var properties = ControlProperties()
    var valueModifiers = [String: (T) -> T]()

    public var didSet: (T) -> Void {
        get { ref.didSet }
        set { ref.didSet = newValue }
    }
    
    var ref: PropertyRef<T>
    
    public var wrappedValue: T {
        get {
            ref.value
        }
        set {
            ref.value = newValue
        }
    }
    
    public var projectedValue: MirrorUI<T> { self }

    public init(wrappedValue: T) {
        self.ref = PropertyRef(value: wrappedValue)
    }
}

extension MirrorUI: MirrorControl {
    
    var mirrorObject: AnyObject {
        return self.ref
    }
}

extension MirrorUI: CaseIterableRefProvider where T: CaseIterable & Equatable {
    
    var caseIterableRef: CaseIterableRef {
        return CaseIterableRef(self.ref)
    }
}
