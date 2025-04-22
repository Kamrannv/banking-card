//
//  HomeView(Builder).swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import SwiftUI

final class HomeViewBuilder {
    @MainActor static func build() -> some View {
        let viewModel = HomeViewModel(
            state: HomeViewState(),
            createUser: DefaultCreateUserUseCase(),
            createCard: DefaultCreateCardUseCase(),
            transfer: DefaultTransferUseCase(),
            remove: DefaultRemoveCardUseCase()
        )
        let container = Container(viewModel: viewModel)
        return HomeView(container: container)
    }
}
