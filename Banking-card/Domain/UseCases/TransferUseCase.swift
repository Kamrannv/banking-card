//
//  TransferUseCase.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

protocol TransferUseCase {
    func execute(from: inout Card, to: inout Card, amount: Double) -> Bool
}

struct DefaultTransferUseCase: TransferUseCase {
    func execute(from: inout Card, to: inout Card, amount: Double) -> Bool {
        guard from.debit(amount) else { return false }
        to.credit(amount)
        return true
    }
}
