import SwiftUI

struct BankCardView: View {
    let card: Card
    let user: User
    let otherCards: [Card]
    let amount: Binding<String>
    let selectedTarget: Binding<UUID?>
    let onRemove: () -> Void
    let onTransfer: () -> Void
    
    @State private var shouldShowCVV: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            cardView
            transferView
        }
        .padding(.horizontal)
    }
    
    
    private var cardView: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.indigo]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 200)
            
            VStack {
                HStack {
                    Text("\(card.balance, specifier: "%.2f") AZN")
                        .foregroundColor(.white)
                        .font(.headline)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.3), value: card.balance)
                    
                    Spacer()
                }
                Spacer(minLength: 0)
                
                Text(formattedCardNumber(card.cardNumber))
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                Spacer(minLength: 0)
                
                HStack {
                    Text("Expiry: 12/28")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("CVV")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)
                        ZStack {
                            Text(card.cvv)
                                .opacity(shouldShowCVV ? 1 : 0)
                            Text(String(repeating: "*", count: card.cvv.count))
                                .opacity(shouldShowCVV ? 0 : 1)
                        }
                        .foregroundColor(.white)
                        .font(.caption.monospacedDigit())
                        .animation(.easeInOut(duration: 0.2), value: shouldShowCVV)
                        .frame(width: 30, height: 30)
                        
                        Button(action: { shouldShowCVV.toggle() }) {
                            Image(systemName: shouldShowCVV ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.8))
                                .imageScale(.small)
                        }
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity)
        }
    }
    
    private var transferView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !otherCards.isEmpty {
                Picker("To Card", selection: selectedTarget) {
                    Text("Select").tag(UUID?.none)
                    ForEach(otherCards, id: \.id) { target in
                        Text(formattedCardNumber(target.cardNumber)).tag(Optional(target.id))
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                
                HStack {
                    TextField("AZN", text: amount)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: onTransfer) {
                        Label("Send", systemImage: "arrow.right.arrow.left")
                            .frame(width: 90)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(amount.wrappedValue.isEmpty || selectedTarget.wrappedValue == nil)
                }
                .padding(.horizontal)
            }
            
            Button(action: onRemove) {
                Label("Remove Card", systemImage: "trash.fill")
                    .foregroundColor(.red)
            }
            .font(.footnote)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
   
 
    private func formattedCardNumber(_ number: String) -> String {
        var formatted = ""
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        
        for (index, character) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(character)
        }
        
        return formatted
    }}
