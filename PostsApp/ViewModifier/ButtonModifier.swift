//
//  ButtonModifier.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import SwiftUI

struct LoginButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 45)
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(5.0)
    }
}

extension View {
    func loginButtonStyle() -> some View {
        modifier(LoginButton())
    }
}

