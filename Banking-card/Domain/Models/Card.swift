//
//  Card.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

struct Card: Identifiable, Equatable {
    let id: UUID
    var cardNumber: String
    var balance: Double
    let cvv: String
    
    mutating func debit(_ amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }
    
    mutating func credit(_ amount: Double) {
        balance += amount
    }
}
