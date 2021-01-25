//
//  TopicViewModelSectionTests.swift
//  MeditateTests
//
//  Created by Duff Neubauer on 1/24/21.
//

import XCTest
@testable import Meditate

class TopicViewModelSectionTests: XCTestCase {

    func testTitle_shouldMatchTopicTitle() {
        let topic = Topic.make(title: "A title")
        let sut = TopicViewModel.Section(topic)
        
        XCTAssertEqual(topic.title, sut.title)
    }
    
}
