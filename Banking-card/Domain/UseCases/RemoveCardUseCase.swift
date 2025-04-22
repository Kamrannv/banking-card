//
//  RemoveCardUseCase.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

protocol RemoveCardUseCase {
    func execute(cards: inout [Card], id: UUID)
}

struct DefaultRemoveCardUseCase: RemoveCardUseCase {
    func execute(cards: inout [Card], id: UUID) {
        cards.removeAll { $0.id == id }
    }
}
