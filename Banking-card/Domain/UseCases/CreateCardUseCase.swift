//
//  CreateCardUseCase.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

protocol CreateCardUseCase {
    func execute(cardNumber: String) -> Card
}

struct DefaultCreateCardUseCase: CreateCardUseCase {
    func execute(cardNumber: String) -> Card {
        Card(id: UUID(), cardNumber: cardNumber, balance: 10, cvv: "123")
    }
}
