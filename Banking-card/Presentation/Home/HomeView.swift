//
//  HomeView.swift
//  Banking-card
//
//  Created by Kamran on 21.04.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var container: Container<HomeViewState, HomeViewEvent, Never>
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.06)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    userForm
                    userListView
                }
                .padding()
            }
        }
    }
    
    private var userForm: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Create user")
                .font(.title2.bold())
            
            FormTextField(title: "Name", text: $container.state.name)
            
            FormTextField(title: "Surname", text: $container.state.surname)
            
            DatePicker("Birth Date", selection: $container.state.birthDate, displayedComponents: .date)
            
            FormTextField(
                title: "GSM Number",
                text: $container.state.gsm,
                keyboardType: .numberPad,
                type: .phone,
                isValid: $container.state.isGsmValid
            )
            
            Button("Create Customer") {
                container.send(
                    .createUser(
                        name: container.state.name,
                        surname: container.state.surname,
                        birthDate: container.state.birthDate,
                        gsm: container.state.gsm
                    ))
                
            }
            .disabled(
                container.state.name.isEmpty
                || container.state.surname.isEmpty
                || container.state.gsm.isEmpty
                || !container.state.isGsmValid
            )
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.white)))
    }
    
    private var userListView: some View {
        ForEach(container.state.users) { user in
            userViewLayer(for: user)
        }
    }

    private func userViewLayer(for user: User) -> some View {
           VStack(alignment: .leading, spacing: 12) {
               Text("\(user.name) \(user.surname)")
                   .font(.title3.bold())

               ForEach(user.cards) { card in

                   VStack(spacing: 16) {
                       cardView(card, for: user)
                       errorText
                   }
                   .padding(.vertical, 16)
                   .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
               }

               VStack(alignment: .leading, spacing: 8) {
                   CardNumberField(title: "16-digit card number", cardNumber: $container.state.newCardNumber)

                   Button("Add Card") {
                       if container.state.newCardNumber.count == 16 {
                           container.send(.createCard(user.id, container.state.newCardNumber))
                       }
                   }
                   .disabled(container.state.newCardNumber.count != 16)
               }
               .padding()
               .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
           }
       }
    
    private func cardView(_ card: Card, for user: User) -> some View {
        let amountBinding = Binding<String>(
            get: { container.state.transferAmounts[card.id] ?? "" },
            set: { container.send(.updateAmount(card.id, $0)) }
        )
        
        let selectedCard = Binding<UUID?>(
            get: { container.state.selectedTargetCard[card.id] },
            set: { container.send(.updateSelectedCard(card.id, $0)) }
        )
        
        let otherCards = user.cards.filter { $0.id != card.id }
        return BankCardView(
            card: card,
            user: user,
            otherCards: otherCards,
            amount: amountBinding,
            selectedTarget: selectedCard,
            onRemove: {
                container.send(.removeCard(card.id, user.id))
            },
            onTransfer: {
                container.send(.transferTapped(from: card.id))
            }
        )
    }
    
    
    private var errorText: some View {
        Group {
            if let error = container.state.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
    }
    
    
}
