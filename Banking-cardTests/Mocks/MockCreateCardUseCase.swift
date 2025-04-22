//
//  MockCreateCardUseCase.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import Foundation

final class MockCreateCardUseCase: CreateCardUseCase {
    var executeCallCount = 0
    var lastExecuteParams: String?
    var mockCard = Card(id: UUID(), cardNumber: "1234567890123456", balance: 100.0, cvv: "123")
    
    func execute(cardNumber: String) -> Card {
        executeCallCount += 1
        lastExecuteParams = cardNumber
        return mockCard
    }
}
