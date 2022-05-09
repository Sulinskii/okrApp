//
//  AppOKRTests.swift
//  AppOKRTests
//
//  Created by Artur Sulinski on 19/12/2021.
//

import XCTest
import Combine
@testable import AppOKR

class AppOKRTests: XCTestCase {

    var authViewModel: AuthViewModel!
    var booksViewModel: BooksViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        authViewModel = AuthViewModel()
        booksViewModel = BooksViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions = []
        authViewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_authVMAgainstMemoryLeak() {
        weak var weakSut = authViewModel
        authViewModel = nil
        XCTAssertNil(weakSut)
    }
    
    func test_booksVMAgainstMemoryLeak() {
        weak var weakSut = booksViewModel
        booksViewModel = nil
        XCTAssertNil(weakSut)
    }
    
    func test_isEmailValid() {
        //Given
        let expected: String = "Email is not valid"
        var result: String = ""
        
        let exp = expectation(description: "Email validation error is published")
        
        authViewModel.$inlineErrorForEmail
            .dropFirst()
            .sink(receiveValue: {
                result = $0
                exp.fulfill()
            })
            .store(in: &subscriptions)
        
        //When
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.authViewModel.email = "artur"
        }
        
        waitForExpectations(timeout: 2)
        
        //Then
        XCTAssert(
            result == expected,
            "Email expected to be \(expected) but was \(result)"
        )
    }
    
    func test_isPasswordValid() {
        //Given
        let expected: String = "Passwords don't match"
        var result: String = ""
        
        let exp = expectation(description: "Password missmatch error is published")
    
        
        authViewModel.$inlineErrorForPassword
            .dropFirst(2)
            .sink(receiveValue: {
                result = $0
                exp.fulfill()
            })
            .store(in: &subscriptions)
        
        //When
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.authViewModel.password = "blabla"
            self.authViewModel.passwordAgain = "ggg"
        }
        
        waitForExpectations(timeout: 3)
        
        //Then
        XCTAssert(
            result == expected,
            "Email expected to be \(expected) but was \(result)"
        )
    }
}
