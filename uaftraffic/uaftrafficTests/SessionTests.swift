//
//  SessionTests.swift
//  uaftrafficTests
//
//  Created by Christopher Bailey on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import XCTest
@testable import uaftraffic

class SessionTests: XCTestCase {
	let session: Session!
	
    override func setUp() {
        session = Session()
    }

    override func tearDown() {
        session = nil
    }
	
	// Sessions IDs should be auto-generated and unique
	func testSessionIdGeneration() {
		let session2 = Session()
		XCTAssertGreaterThan(session.id.count, 0)
		XCTAssertGreaterThan(session2.id.count, 0)
		XCTAssertNotEqual(session.id, session2.id)
	}

	// addCrossing method should work
	func testAddCrossing() {
		session.addCrossing("car", "w", "n" )
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
	}
	
	// addCrossing should work multiple times
	func testAddTwoCrossings() {
		
		// Test first crossing
		session.addCrossing("car", "w", "n" )
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
		
		// Test second crossing
		session.addCrossing("pedestrian", "e", "s" )
		XCTAssertEqual(session.crossings[1].type, "pedestrian")
		XCTAssertEqual(session.crossings[1].from, "e")
		XCTAssertEqual(session.crossings[1].to, "s")
		XCTAssertEqual(session.crossings.count, 2)
	}
	
	// undo should remove the last crossing
	func testUndo() {
		// Test first crossing
		session.addCrossing("car", "w", "n" )
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
		
		// Test second crossing
		session.addCrossing("pedestrian", "e", "s" )
		XCTAssertEqual(session.crossings[1].type, "pedestrian")
		XCTAssertEqual(session.crossings[1].from, "e")
		XCTAssertEqual(session.crossings[1].to, "s")
		XCTAssertEqual(session.crossings.count, 2)
		
		// Test undo second crossing
		session.undo()
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
	}
}
