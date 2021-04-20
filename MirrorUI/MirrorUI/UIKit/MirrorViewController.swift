//
//  MirrorViewController.swift
//  MirrorUI
//
//  Created by Steven Barnegren on 19/04/2021.
//

#if os(iOS)

import Foundation
import SwiftUI

public class MirrorViewController: UIHostingController<MirrorView> {
    
    public init(object: AnyObject, viewMapper: ViewMapper = .shared) {
        let mirrorView = MirrorView(object: object, viewMapper: viewMapper)
        super.init(rootView: mirrorView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
