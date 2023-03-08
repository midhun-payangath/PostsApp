//
//  LoginView.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(StringContant.txt.appTitle)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                    .frame(height: 50)
                ZStack {
                    VStack(alignment: .center){
                        Text(StringContant.txt.signIn)
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                            .frame(height: 50)
                        TextField(StringContant.txt.enterUserID, text: $loginViewModel.userId)
                            .loginextFieldStyle()
                        Spacer()
                            .frame(height: 20)
                        Button(StringContant.txt.signIn) {
                            loginViewModel.didTapLoginButton()
                        }
                        .loginButtonStyle()
                        .hidden(!loginViewModel.formIsValid)
                    }
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 50, trailing: 20))
                    .background(Color.systemGray6)
                }
                .cornerRadius(10)
                .shadow(color: Color.gray, radius: 3)
                .padding(20)
            }
            .navigationDestination(isPresented: $loginViewModel.loginSuccess) {
            }
        }
        .loaderViewWrapper(isLoading: loginViewModel.isLoading)
        .withErrorHandling(error: $loginViewModel.viewModelError)
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


