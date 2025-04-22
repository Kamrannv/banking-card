//
//  Container.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.

import SwiftUI
import Combine

@MainActor
open class Container<S: UIState, I: UIIntent, R>: ObservableObject {
    @Published public var state: S
    let viewModel: BaseViewModel<S, I, R>
    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: BaseViewModel<S, I, R>) {
        self.viewModel = viewModel
        self.state = viewModel.state

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] newState in
                self?.state = newState
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    public func send(_ event: I) {
        viewModel.send(event)
    }
}

