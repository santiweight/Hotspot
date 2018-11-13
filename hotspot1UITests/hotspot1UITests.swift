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
//        UIViewController = navigationController.topViewController as! ViewController
//
//        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
//
//        // Test and Load the View at the Same Time!
//        XCTAssertNotNil(navigationController.view)
//        XCTAssertNotNil(viewController.view)

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOpenLoginWindow() {
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
//        app.alerts["“hotspot1” Wants to Use “oktapreview.com” to Sign In"].buttons["Continue"].tap()
//
//        
//        let webViewsQuery = XCUIApplication().webViews
//        let usernameField = webViewsQuery/*@START_MENU_TOKEN@*/.textFields["Username"]/*[[".otherElements[\"Harvey Mudd College-dev-158434 - Sign In\"].textFields[\"Username\"]",".textFields[\"Username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        let passwordField = webViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".otherElements[\"Harvey Mudd College-dev-158434 - Sign In\"].secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        let rememberMeCheck = webViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Remember me"]/*[[".otherElements[\"Harvey Mudd College-dev-158434 - Sign In\"]",".otherElements[\"Remember me\"].staticTexts[\"Remember me\"]",".staticTexts[\"Remember me\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//        
//        XCTAssertTrue(usernameField.exists)
//        XCTAssertFalse(passwordField.exists)
//        XCTAssertFalse(rememberMeCheck.exists)

        

        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
        func testOpenRegisterWindow(){
        
    }

}
