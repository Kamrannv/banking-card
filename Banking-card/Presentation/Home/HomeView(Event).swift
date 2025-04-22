//
//  HomeView(Event).swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation

enum HomeViewEvent: UIIntent {
    case createUser(name: String, surname: String, birthDate: Date, gsm: String)
    case createCard(UUID, String)
    case removeCard(UUID, UUID)
    case transferTapped(from: UUID)
    case updateSelectedCard(UUID, UUID?)
    case updateAmount(UUID, String)
}
