//
//  LoginViewModel.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    private var bindings = Set<AnyCancellable>()
    private let loginService = LoginService()
    @Published var isLoading: Bool = false
    @Published var viewModelError: LoginViewModelError?
    @Published var userId = ""
    @Published var formIsValid: Bool = false
    @Published var loginSuccess: Bool = false

    
    init() {
        isValidUserId
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &bindings)
    }
    
    
    func didTapLoginButton() {
        viewModelError = nil
        isLoading = true
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
                switch error {
                case .network(let msg), .other(let msg):
                    self?.viewModelError = .other(msg.localizedDescription)
                case .decoding(_):
                    self?.viewModelError = .userNotFound
                }
            case .finished:
                break
            }
        }
        let request = LoginRequest(userId: userId)
        loginService.userLogin(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: { [weak self] loginResponse in
                guard let self = self else { return}
                Keychain.set(loginResponse.id.description, forKey: AppConstant.Keychain.loggedInUser)
                self.userId = ""
                self.loginSuccess = true
                
            })
            .store(in: &bindings)
    }
    
}

private extension LoginViewModel {
    var isValidUserId: AnyPublisher<Bool, Never> {
        $userId
            .map { $0.count > 0}
            .eraseToAnyPublisher()
    }
}
