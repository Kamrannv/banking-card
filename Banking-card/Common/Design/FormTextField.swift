//
//  FormTextField.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import SwiftUI

enum FieldType {
    case text
    case phone
}

struct FormTextField: View {
    let title: String
    var keyboardType: UIKeyboardType = .default
    var type: FieldType = .text
    
    @Binding var text: String
    @Binding var isValid: Bool
    
    @State var errorMessage: String?
    
    init(
        title: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        type: FieldType = .text,
        isValid: Binding<Bool>? = nil
    ) {
        self.title = title
        self._text = text
        self.keyboardType = keyboardType
        self.type = type
        self._isValid = isValid ?? .constant(true)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .autocorrectionDisabled(true)
                .padding(12)
                .background(Color(.gray).opacity(0.06))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
                )
                .onChange(of: text) {
                    if type == .phone {
                        handlePhoneInputChange()
                    }
                }
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func handlePhoneInputChange() {
        let digitsOnly = text.filter { $0.isNumber }
        
        guard digitsOnly.count <= 10 else {
            text = formatPhone(String(digitsOnly.prefix(10)))
            return
        }
        
        let formatted = formatPhone(digitsOnly)
        text = formatted
        
        if digitsOnly.isEmpty || isValidPrefix(digitsOnly) {
            errorMessage = nil
            isValid = digitsOnly.count == 10
        } else {
            errorMessage = "Prefix must be 050, 051, 055, 060, 070, 077, or 090"
            isValid = false
        }
    }
    
    
    
    private func formatPhone(_ number: String) -> String {
        let maxLength = 10
        let trimmed = String(number.prefix(maxLength))
        
        var result = ""
        let chars = Array(trimmed)
        
        for (index, char) in chars.enumerated() {
            if index == 3 || index == 6 || index == 8 {
                result.append(" ")
            }
            result.append(char)
        }
        return result
    }
    
    private func isValidPrefix(_ number: String) -> Bool {
        let prefixRegex = #"^(050|051|055|060|070|077|090)"#
        return number.range(of: prefixRegex, options: .regularExpression) != nil
    }
}
