//
//  MockCreateUserUseCase.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//

import Foundation
@testable import Banking_card

final class MockCreateUserUseCase: CreateUserUseCase {
    var executeCallCount = 0
    var lastExecuteParams: (name: String, surname: String, birthDate: Date, gsm: String)?
    var mockUser = User(id: UUID(), name: "Test", surname: "User", birthDate: Date(), gsm: "050 123 45 67", cards: [])
    
    public func execute(name: String, surname: String, birthDate: Date, gsm: String) -> User {
        executeCallCount += 1
        lastExecuteParams = (name, surname, birthDate, gsm)
        return mockUser
    }
}
