//
//  CombineTestCase.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import Combine
import XCTest

class CombineTestCase: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    func await<Value, Failure : Error>(_ publisher: AnyPublisher<Value, Failure>) throws -> Value {
        var expectation: XCTestExpectation? = self.expectation(description: "To receive values from Publisher")
        var result: Result<Value, Failure>!
        
        var subscription: AnyCancellable?
        let cancelSubscription: () -> Void = {
            subscription?.cancel()
            subscription = nil
        }
        
        subscription = publisher.sink { _ in
        } receiveValue: { value in
            result = .success(value)
            expectation?.fulfill()
            expectation = nil
            cancelSubscription()
        }
        
        waitForExpectations(timeout: 1.0)
        
        return try result.get()
    }

}
