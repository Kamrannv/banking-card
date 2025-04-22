//
//  Untitled.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import Foundation
@testable import Banking_card

class MockRemoveCardUseCase: RemoveCardUseCase {
    var executeCallCount = 0
    var lastExecuteParams: (cards: [Card], id: UUID)?
    
    func execute(cards: inout [Card], id: UUID) {
        executeCallCount += 1
        lastExecuteParams = (cards, id)
        cards.removeAll { $0.id == id }
    }
}
