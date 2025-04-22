//
//  BaseViewModel.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//

import SwiftUI

@MainActor
open class BaseViewModel<S: UIState, I: UIIntent, R>: ObservableObject {
    @Published public var state: S

    public init(state: S) {
        self.state = state
    }
    public func send(_ event: I) {
        trigger(event)
    }

    open func trigger(_ event: I) {
        
    }

    public func update(_ update: @escaping (inout S) -> Void) {
        update(&state)
    
    }

}
