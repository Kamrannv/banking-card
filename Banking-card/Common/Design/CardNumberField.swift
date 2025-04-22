//
//  CardNumberField.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import SwiftUI

struct CardNumberField: View {
    let title: String
    @Binding var cardNumber: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: $cardNumber)
                .keyboardType(.numberPad)
                .autocorrectionDisabled(true)
                .textFieldStyle(.roundedBorder)
                .onChange(of: cardNumber) {
                    filterCardInput()
                }
        }
    }

    private func filterCardInput() {
        let digits = cardNumber.filter { $0.isNumber }
        cardNumber = String(digits.prefix(16))
    }
}

