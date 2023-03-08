//
//  LoaderModifier.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import SwiftUI

struct LoaderModifier: ViewModifier {
    
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            withAnimation {
                content
                    .disabled(isLoading)
                    .blur(radius: isLoading ? 10 : 0)
                    .clipped()
            }
            if isLoading {
                VStack {
                    Text(StringContant.txt.loading)
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondary.colorInvert().ignoresSafeArea())
                .foregroundColor(Color.black)
                .opacity(isLoading ? 1 : 0)
            }
        }
    }
}

extension View {
    func loaderViewWrapper(isLoading: Bool) -> some View {
        modifier(LoaderModifier(isLoading: isLoading))
    }
}
