//
//  MirrorControlsView.swift
//  MirrorControlsExample
//
//  Created by Steve Barnegren on 10/01/2021.
//

import SwiftUI

struct ObjectProperty: Identifiable {
    var id: String { name }
    let name: String
    let displayName: String
    var viewStateStorage: Ref<[String: Any]> = Ref(value: [:])
    var objectRef: AnyObject
    var viewDisplaysTitle = false
}

protocol MirrorControl {
    var mirrorObject: AnyObject { get }
    var properties: ControlProperties { get }
}

class ReloadTrigger: ObservableObject {
    @Published var reloadToggle = false
    func reload() {
        reloadToggle.toggle()
    }
}

public struct MirrorView: View {
    
    private let object: AnyObject
    private let objectProperties: [ObjectProperty]
    private let viewMapper = ViewMapper.defaultMapper
    @ObservedObject private var reloadTrigger: ReloadTrigger
    
    public init(object: AnyObject) {
        self.object = object
        let objectProperties = Self.getProperties(from: object)
        
        let reloadTrigger = ReloadTrigger()
        for property in objectProperties {
            property.viewStateStorage.didSet = { _ in
                reloadTrigger.reload()
            }
            if let didSetCaller = property.objectRef as? InternalDidSetCaller {
                didSetCaller.internalDidSet = {
                    reloadTrigger.reload()
                }
            }
        }
        
        self.objectProperties = objectProperties
        self.reloadTrigger = reloadTrigger
    }
    
    static func getProperties(from object: AnyObject) -> [ObjectProperty] {
        
        let children = Mirror(reflecting: object).children
        var properties = [ObjectProperty]()
        
        for child in children where child.value is MirrorControl {
            let mirrorControl = child.value as! MirrorControl
            guard let label = child.label else { continue }
            let property = ObjectProperty(
                name: label,
                displayName: PropertyNameFormatter.displayName(forPropertyName: label),
                objectRef: mirrorControl.mirrorObject)
            
            properties.append(property)
        }
        
        return properties
    }
    
    public var body: some View {
        
        List {
            
            ForEach(objectProperties) { property -> AnyView in
                
                let controlView = self.makeControlView(
                    propertyName: property.name,
                    displayName: property.displayName,
                    state: property.viewStateStorage
                )
                
                let stack = VStack {
                    if !viewMapper.mappingDisplaysTitle(forObject: property.objectRef) {
                        HStack {
                            Text(property.displayName)
                            Spacer()
                        }
                    }
                    controlView
                }
                return AnyView(stack)
            }
        }
    }
    
    private func makeControlView(propertyName: String, displayName: String, state: Ref<[String: Any]>) -> AnyView {
         let value = Mirror(reflecting: object).children
            .first { $0.label == propertyName }
            .flatMap { $0.value }!
        
        guard let control = value as? MirrorControl else {
            assertionFailure("All properties should be mirror controls")
            return makeNoMappingView()
        }
        
        let context = ViewMappingContext(
            propertyName: displayName,
            properties: control.properties,
            state: state,
            reloadTrigger: self.reloadTrigger
        )
        
        if let caseIterableRefProvider = control as? CaseIterableRefProvider {
            return ViewMapping.makeCaseIterableView(ref: caseIterableRefProvider.caseIterableRef,
                                                    context: context)
        } else {
            return viewMapper.createView(object: control.mirrorObject, context: context) ?? makeNoMappingView()
        }
    }
    
    private func makeNoMappingView() -> AnyView {
        let text = Text("No mapping").foregroundColor(.gray).italic()
        return AnyView(text)
    }
}
/*
struct MirrorControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        MirrorView(object: settings)
    }
}
*/
