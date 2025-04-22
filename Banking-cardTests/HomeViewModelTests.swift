//
//  HomeViewModelTests.swift
//  Banking-cardTests
//
//  Created by Kamran on 22.04.25.
//
import Testing
import Foundation
@testable import Banking_card

@Suite("HomeViewModel Tests")
struct HomeViewModelTests: HomeViewModelSpecs {
    
    @MainActor
    func sut() -> (
        HomeViewModel,
        MockCreateUserUseCase,
        MockCreateCardUseCase,
        MockTransferUseCase,
        MockRemoveCardUseCase
    ) {
        let state = HomeViewState()
        let mockCreateUser = MockCreateUserUseCase()
        let mockCreateCard = MockCreateCardUseCase()
        let mockTransfer = MockTransferUseCase()
        let mockRemove = MockRemoveCardUseCase()
        
        let viewModel = HomeViewModel(
            state: state,
            createUser: mockCreateUser,
            createCard: mockCreateCard,
            transfer: mockTransfer,
            remove: mockRemove
        )
        
        return (viewModel, mockCreateUser, mockCreateCard, mockTransfer, mockRemove)
    }
    
    @Test("Creating a user should add them to the state")
    func testCreateUser() async throws {
        let (vm, mock, _, _, _) = await sut()
        let name = "John", surname = "Doe", gsm = "0501234567", birth = Date()
        await vm.trigger(.createUser(name: name, surname: surname, birthDate: birth, gsm: gsm))
        await #expect(vm.state.users.count == 1)
        #expect(mock.executeCallCount == 1)
        #expect(mock.lastExecuteParams?.name == name)
    }
    
    @Test("Creating a card should add it to the correct user")
    func testCreateCard() async throws {
        let (vm, _, mock, _, _) = await sut()
        let userID = UUID()
        let testUser = await createTestUser(id: userID)
        
        await vm.update { $0.users.append(testUser) }
        await vm.trigger(.createCard(userID, "4444333322221111"))
        await #expect(vm.state.users[0].cards.count == 1)
        #expect(mock.executeCallCount == 1)
    }
    
    @Test("Successful transfer should update both card balances")
    func testSuccessfulTransfer() async throws {
        let (vm, fromID, _, _) = await setupTransferScenario()
        await vm.trigger(.transferTapped(from: fromID))
        try await Task.sleep(nanoseconds: 1_500_000_000)
        await verifyTransferResults(
            viewModel: vm,
            expectedFromBalance: 50.0,
            expectedToBalance: 50.0
        )
    }
    
    @Test("Transfer with insufficient balance should show error")
    func testTransferInsufficientBalance() async throws {
        let (vm, fromID, _, mock) = await setupTransferScenario(
            fromBalance: 30.0,
            transferAmount: "100",
            shouldSucceed: false
        )
        await vm.trigger(.transferTapped(from: fromID))
        await verifyTransferResults(
            viewModel: vm,
            expectedFromBalance: 30.0,
            expectedToBalance: 0.0,
            expectedErrorMessage: "Not enough balance"
        )
        #expect(mock.executeCallCount == 1)
    }
    @Test("Transfer with empty amount should show error")
    func testEmptyAmountTransfer() async throws {
        let (vm, fromID, _, mock) = await setupTransferScenario(transferAmount: "")
        await vm.trigger(.transferTapped(from: fromID))
        await verifyTransferResults(
            viewModel: vm,
            expectedFromBalance: 100.0,
            expectedToBalance: 0.0,
            expectedErrorMessage: "Enter a valid amount"
        )
        #expect(mock.executeCallCount == 0)
    }
    
    @Test("Transfer with invalid amount should show error")
    func testInvalidAmountTransfer() async throws {
        let (vm, fromID, _, mock) = await setupTransferScenario(transferAmount: "notANumber")
        await vm.trigger(.transferTapped(from: fromID))
        await verifyTransferResults(
            viewModel: vm,
            expectedFromBalance: 100.0,
            expectedToBalance: 0.0,
            expectedErrorMessage: "Enter a valid amount"
        )
        #expect(mock.executeCallCount == 0)
    }
    @Test("Transfer between cards of different users")
    func testTransferBetweenDifferentUsers() async throws {
        let (vm, fromID, _, mock) = await setupMultiUserTransferScenario()
        await vm.trigger(.transferTapped(from: fromID))
        #expect(mock.executeCallCount == 0)
        await #expect(vm.state.users[0].cards[0].balance == 100.0)
        await #expect(vm.state.users[1].cards[0].balance == 0.0)
    }
    
    @Test("Remove card removes it from the user's cards")
    func testRemoveCard() async throws {
        let (vm, _, _, _, mock) = await sut()
        let userId = UUID(), cardId = UUID()
        let card = Card(id: cardId, cardNumber: "4444", balance: 10, cvv: "111")
        let user = User(id: userId, name: "A", surname: "B", birthDate: .now, gsm: "000", cards: [card])
        await vm.update { $0.users.append(user) }
        await vm.trigger(.removeCard(cardId, userId))
        await #expect(vm.state.users[0].cards.isEmpty)
        #expect(mock.executeCallCount == 1)
    }
    
    
    //MARK: Helpers
    @MainActor
    func createTestUser(
        id: UUID = UUID(),
        name: String = "Test",
        surname: String = "User",
        birthDate: Date = .now,
        gsm: String = "0501234567",
        cards: [Card] = []
    ) -> User {
        return User(id: id, name: name, surname: surname, birthDate: birthDate, gsm: gsm, cards: cards)
    }
    func createTestCard(
        id: UUID = UUID(),
        cardNumber: String = "1234567890123456",
        balance: Double = 100.0,
        cvv: String = "123"
    ) -> Card {
        return Card(id: id, cardNumber: cardNumber, balance: balance, cvv: cvv)
    }
    @MainActor
    func setupTransferScenario(
        fromBalance: Double = 100.0,
        toBalance: Double = 0.0,
        transferAmount: String = "50",
        shouldSucceed: Bool = true
    ) async -> (
        viewModel: HomeViewModel,
        fromID: UUID,
        toID: UUID,
        transferMock: MockTransferUseCase
    ) {
        let (vm, _, _, transferMock, _) =  sut()
        transferMock.shouldSucceed = shouldSucceed
        
        let fromID = UUID(), toID = UUID()
        let fromCard = createTestCard(id: fromID, balance: fromBalance)
        let toCard = createTestCard(id: toID, balance: toBalance)
        
        let user = createTestUser(cards: [fromCard, toCard])
        
        vm.update {
            $0.users = [user]
            $0.selectedTargetCard[fromID] = toID
            $0.transferAmounts[fromID] = transferAmount
        }
        
        return (vm, fromID, toID, transferMock)
    }
    
    @MainActor
    func verifyTransferResults(
        viewModel: HomeViewModel,
        expectedFromBalance: Double,
        expectedToBalance: Double,
        expectedErrorMessage: String? = nil
    ) async {
        #expect(viewModel.state.users[0].cards[0].balance == expectedFromBalance)
        #expect(viewModel.state.users[0].cards[1].balance == expectedToBalance)
        
        if let expectedError = expectedErrorMessage {
            #expect(viewModel.state.errorMessage == expectedError)
        }
    }
    @MainActor
    func setupMultiUserTransferScenario(
        fromBalance: Double = 100.0,
        toBalance: Double = 0.0,
        transferAmount: String = "50"
    ) async -> (
        viewModel: HomeViewModel,
        fromID: UUID,
        toID: UUID,
        transferMock: MockTransferUseCase
    ) {
        let (vm, _, _, transferMock, _) =  sut()
        
        let fromID = UUID(), toID = UUID()
        let fromCard = createTestCard(id: fromID, balance: fromBalance)
        let toCard = createTestCard(id: toID, balance: toBalance)
        
        let user1 = createTestUser(cards: [fromCard])
        let user2 = createTestUser(cards: [toCard])
        
        vm.update {
            $0.users = [user1, user2]
            $0.selectedTargetCard[fromID] = toID
            $0.transferAmounts[fromID] = transferAmount
        }
        
        return (vm, fromID, toID, transferMock)
    }
    
}
