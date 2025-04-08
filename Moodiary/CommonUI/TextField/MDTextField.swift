//
//  OUTextField.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/3/24.
//

import SwiftUI

struct MDTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var style: MDTextFieldStyle = .standard
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var onCommit: (() -> Void)?
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if style == .floating && (isEditing || !text.isEmpty) {
                Text(placeholder)
                    .font(.pretendardRegular(12))
                    .foregroundColor(.gray)
                    .transition(.move(edge: .top))
            }
            
            ZStack(alignment: .leading) {
                if text.isEmpty && !isEditing {
                    Text(placeholder)
                        .font(.pretendardRegular(16))
                        .foregroundColor(.gray)
                }
                
                Group {
                    if isSecure {
                        SecureField("", text: $text, onCommit: {
                            onCommit?()
                        })
                    } else {
                        TextField("", text: $text, onEditingChanged: { editing in
                            withAnimation {
                                self.isEditing = editing
                            }
                        }, onCommit: {
                            onCommit?()
                        })
                    }
                }
                .font(.pretendardRegular(16))
                .foregroundColor(.black)
                .accentColor(.blue)
                .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(style.backgroundColor)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(isEditing ? Color.blue : style.borderColor, lineWidth: 1)
        )
    }
}

enum MDTextFieldStyle {
    case standard, floating, underlined
    
    var backgroundColor: Color {
        switch self {
        case .standard, .floating:
            return Color(.systemBackground)
        case .underlined:
            return .clear
        }
    }
    
    var borderColor: Color {
        switch self {
        case .standard, .floating:
            return Color(.systemGray4)
        case .underlined:
            return .clear
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .standard, .floating:
            return 8
        case .underlined:
            return 0
        }
    }
}


// 사용 예시
//struct ContentView: View {
//    @State private var text = ""
//    @State private var secureText = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            OUTextField(text: $text, placeholder: "Username", style: .standard)
//
//            OUTextField(text: $secureText, placeholder: "Password", isSecure: true, style: .floating)
//
//            OUTextField(text: $text, placeholder: "Email", style: .underlined, keyboardType: .emailAddress)
//        }
//        .padding()
//    }
//}
