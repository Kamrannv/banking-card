//
//  Banking_cardUITests.swift
//  Banking-cardUITests
//
//  Created by Kamran on 21.04.25.
//

import XCTest

final class Banking_cardUITests: XCTestCase {
    let app = XCUIApplication()

      override func setUpWithError() throws {
          continueAfterFailure = false
          app.launchArguments = ["UI-TESTING"]
      }

      func testCreatingUserAndCardFlow() {
          AppRobot(app: app)
              .launch()
              .home { home in
                   home
                      .fillUserForm(name: "Kamran", surname: "Namazov", gsm: "0501234567")
                      .tapCreateCustomer()
              }
              .home { home in
                  home.assertUserExists("Kamran Namazov")
                      .addCard(number: "1234567890123456")
                      .assertCardExists("1234 5678 9012 3456")
              }
      }
}
