//
//  alamoFireTest.swift
//  alamoFireTest
//
//  Created by Zack Rossman on 11/12/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import XCTest
@testable import hotspot1

class alamoFireTest: XCTestCase {
    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidGeocodeManagerequest() {
        // given
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=222_W_Avenida_Valencie&key=AIzaSyC5agT4X8NX9Rkio1NB_Bhp1J6au5qCLL8")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //fails because of incomplete headers
    func testIncompleteOktaNewUserRequest() {
        let url = URL(string: "https://dev-158434.oktapreview.com/api/v1/users?activate=true")
        let promise = expectation(description: "Status code: 403")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 403 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
