//
//  MirrorUI.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import Foundation

@propertyWrapper public struct MirrorUI<T> {

    public var name: String?

    var properties = ControlProperties()
    
    public var didSet: (T) -> Void {
        get { ref.didSet }
        set { ref.didSet = newValue }
    }
    
    var ref: Ref<T>
    
    public var wrappedValue: T {
        ref.value
    }

    public init(wrappedValue: T) {
        self.ref = Ref(value: wrappedValue)
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
