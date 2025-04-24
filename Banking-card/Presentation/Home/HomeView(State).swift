//
//  Home(State).swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//
import Foundation
import SwiftUI

class HomeViewState: UIState {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var transferAmounts: [UUID: String] = [:]
    @Published var selectedTargetCard: [UUID: UUID] = [:]
    
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var birthDate: Date = Date()
    @Published var gsm: String = ""
    @Published var isGsmValid: Bool = false
    
    @Published var newCardNumber = ""
    
     func setError(_ message: String?) {
        self.errorMessage = message
    }
}
