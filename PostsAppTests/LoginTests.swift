//
//  LoginTests.swift
//  PostsAppTests
//
//  Created by MacBook Pro on 09/03/23.
//

import XCTest
import Combine
@testable import PostsApp

final class LoginTests: XCTestCase {

    private var viewModel: LoginViewModel!
    private var bindings: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    func testUserIdFieldValidationSuccess() {
        
        viewModel.userId = "1"
        RunLoop.main.run(mode: .default, before: .distantPast) // << wait one event
        XCTAssertTrue(viewModel.formIsValid)
    }
    
    func testUserIdFieldValidationFailure() {
        viewModel.userId = ""
        RunLoop.main.run(mode: .default, before: .distantPast) // << wait one event
        XCTAssertFalse(viewModel.formIsValid)
    }
    
    func testLoginApi() {
        
        let expectation = self.expectation(description: "Wait for testLoginApi to complete")
        let completionHandler: (Subscribers.Completion<APIError>) -> Void = {completion in
            switch completion {
            case .failure(let error):
                switch error {
                case .network(let msg):
                    XCTAssert(msg is URLError)
                    expectation.fulfill()
                case .decoding(let msg):
                    XCTAssert(msg is DecodingError)
                    expectation.fulfill()
                    break
                case .other(_):
                    expectation.fulfill()
                    break
                }
            case .finished:
                expectation.fulfill()
                break
            }
        }
        
        let request = LoginRequest(userId: "1")
        viewModel.loginService.userLogin(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: {loginResponse in
                XCTAssertNotNil(loginResponse)
                XCTAssertEqual(loginResponse.id.description, "1")
            })
            .store(in: &bindings)
        wait(for: [expectation], timeout: 10)
    }
    
    func testUserIdKeychainSaveSuccess() {
        
        let userId = "2"
        Keychain.set(userId, forKey: AppConstant.Keychain.loggedInUser)
        let loggedInUserId = Keychain.value(forKey: AppConstant.Keychain.loggedInUser) ?? ""
        XCTAssertEqual(loggedInUserId, userId)
    }
}
