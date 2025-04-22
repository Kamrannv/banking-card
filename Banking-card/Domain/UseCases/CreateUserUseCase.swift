//
//  CreateUser.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

protocol CreateUserUseCase {
    func execute(name: String, surname: String, birthDate: Date, gsm: String) -> User
}

struct DefaultCreateUserUseCase: CreateUserUseCase {
    func execute(name: String, surname: String, birthDate: Date, gsm: String) -> User {
        User(id: UUID(), name: name, surname: surname, birthDate: birthDate, gsm: gsm)
    }
}
