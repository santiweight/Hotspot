//
//  hotspot1UITests.swift
//  hotspot1UITests
//
//  Created by Zack Rossman on 11/12/18.
//  Copyright © 2018 CS121. All rights reserved.
//

import XCTest
import UIKit
@testable import hotspot1

class hotspot1UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOpenChooseLoginWindow() {
        var loginButton = app.buttons["Login"]
        var registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists)
        XCTAssertTrue(loginButton.exists)
        
        registerButton.tap()
        app.buttons["Back"].tap()
        
        loginButton = app.buttons["Login"]
        registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists)
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
        
        //rest is encapsulated in Okta API, no need to test
    }
    
    func testOpenRegisterView() {
        app.buttons["Register"].tap()
        let nameField = app.textFields["Name"]
        let emailField = app.textFields["Email"]
        let submitButton = app.buttons["Submit"]

        XCTAssertTrue(nameField.exists)
        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(submitButton.exists)
        
        submitButton.tap()
    }
    
    
    func testOpeningMapView(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    }

}
