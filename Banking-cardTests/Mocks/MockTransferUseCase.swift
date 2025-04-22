
//
//  MockTransferUseCase.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
@testable import Banking_card

final class MockTransferUseCase: TransferUseCase {
    var executeCallCount = 0
    var lastExecuteParams: (from: Card, to: Card, amount: Double)?
    var shouldSucceed = true
    
    func execute(from: inout Card, to: inout Card, amount: Double) -> Bool {
        executeCallCount += 1
        lastExecuteParams = (from, to, amount)
        
        if shouldSucceed {
            from.balance -= amount
            to.balance += amount
            return true
        } else {
            return false
        }
    }
}
