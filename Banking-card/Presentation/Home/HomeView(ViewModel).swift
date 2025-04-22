//
//  HomeView(ViewModel).swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

final class HomeViewModel: BaseViewModel<HomeViewState, HomeViewEvent, Never> {
    private let createUser: CreateUserUseCase
    private let createCard: CreateCardUseCase
    private let transfer: TransferUseCase
    private let remove: RemoveCardUseCase
    
    init(
        state: HomeViewState,
        createUser: CreateUserUseCase,
        createCard: CreateCardUseCase,
        transfer: TransferUseCase,
        remove: RemoveCardUseCase
    ) {
        self.createUser = createUser
        self.createCard = createCard
        self.transfer = transfer
        self.remove = remove
        super.init(state: state)
    }
    
    override func trigger(_ event: HomeViewEvent) {
        switch event {
        case let .createUser(name, surname, birth, gsm):
            createUser(name: name, surname: surname, birth: birth, gsm: gsm)
            
        case let .createCard(userId, cardNumber):
            createCard(for: userId, number: cardNumber)
            
        case let .removeCard(cardID, userId):
            removeCard(cardID: cardID, userId: userId)
            
        case let .transferTapped(fromID):
            transferTapped(fromID: fromID)
        case let .updateSelectedCard(fromID, toID):
            update {
                $0.selectedTargetCard[fromID] = toID
            }
            
        case let .updateAmount(cardID, value):
            update {
                $0.transferAmounts[cardID] = value
            }
        }
    }
    
    
    private func transferTapped(fromID: UUID) {
        guard
            let toID = state.selectedTargetCard[fromID],
            
                let rawInput = state.transferAmounts[fromID]
        else {
            validateCard()
            return
        }
        
        let cleaned = rawInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let amount = Double(cleaned), amount > 0 else {
            validateCard()
            return
        }
        
        transferBalance(fromID: fromID, toID: toID, amount: amount)
        
        self.transferCleanUp(fromID)
    }
    
    private func transferCleanUp(_ cardID: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.update {
                $0.transferAmounts[cardID] = ""
                $0.selectedTargetCard[cardID] = nil
            }
        }
    }
    private func validateCard() {
        update { $0.setError("Enter a valid amount") }
    }
    private func createUser(name: String, surname: String, birth: Date, gsm: String) {
        let user = createUser.execute(name: name, surname: surname, birthDate: birth, gsm: gsm)
        update { $0.users.append(user) }
        
        resetState()
    }
    
    private func resetState() {
        state.name = ""
        state.surname = ""
        state.gsm = ""
        state.birthDate = Date()
    }
    
    private func createCard(for userId: UUID, number: String) {
        update {
            if let index = $0.users.firstIndex(where: { $0.id == userId }) {
                let newCard = self.createCard.execute(cardNumber: number)
                $0.users[index].cards.append(newCard)
                self.state.newCardNumber = ""
            }
        }
    }
    
    private func findCardIndexes(in cards: [Card], fromID: UUID, toID: UUID) -> (Int, Int)? {
        guard let fromIndex = cards.firstIndex(where: { $0.id == fromID }),
              let toIndex = cards.firstIndex(where: { $0.id == toID }) else {
            return nil
        }
        return (fromIndex, toIndex)
    }
    
    private func updateState(
        in cards: inout [Card],
        fromCard: Card,
        toCard: Card,
        fromIndex: Int,
        toIndex: Int
    ) {
        cards[fromIndex] = fromCard
        cards[toIndex] = toCard
    }
    
    private func performTransfer(state: inout HomeViewState, fromID: UUID, toID: UUID, amount: Double) {
        for index in state.users.indices {
            let cards = state.users[index].cards
            guard let (
                fromIndex,
                toIndex) = findCardIndexes(
                    in: cards,
                    fromID: fromID,
                    toID: toID
                ) else { continue }
            
            var fromCard = cards[fromIndex]
            var toCard = cards[toIndex]
            
            if transfer.execute(from: &fromCard, to: &toCard, amount: amount) {
                updateState(
                    in: &state.users[index].cards,
                    fromCard: fromCard,
                    toCard: toCard,
                    fromIndex: fromIndex,
                    toIndex: toIndex
                )
                state.setError(nil)
            } else {
                state.setError("Not enough balance")
            }
        }
    }
    
    private func transferBalance(fromID: UUID, toID: UUID, amount: Double) {
        update {
            self.performTransfer(
                state: &$0,
                fromID: fromID,
                toID: toID,
                amount: amount
            )
        }
    }
    
    private func removeCard(cardID: UUID, userId: UUID) {
        update {
            if let i = $0.users.firstIndex(where: { $0.id == userId }) {
                self.remove.execute(cards: &$0.users[i].cards, id: cardID)
            }
        }
    }
}
