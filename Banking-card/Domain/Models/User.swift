//
//  User.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    var name: String
    var surname: String
    var birthDate: Date
    var gsm: String
    var cards: [Card] = []
}
