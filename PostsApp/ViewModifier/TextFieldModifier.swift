//
//  TextFieldModifier.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import SwiftUI

struct LoginTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color.systemGray5)
            .cornerRadius(5.0)
    }
}

extension View {
    func loginextFieldStyle() -> some View {
        modifier(LoginTextField())
    }
}
