//
//  HomeRobot.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import XCTest

struct HomeRobot {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    @discardableResult
    func fillUserForm(name: String, surname: String, gsm: String) -> Self {
        let nameField = app.textFields["Name"]
        let surnameField = app.textFields["Surname"]
        let gsmField = app.textFields["GSM Number"]

        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText(name)

        XCTAssertTrue(surnameField.waitForExistence(timeout: 2))
        surnameField.tap()
        surnameField.typeText(surname)

        XCTAssertTrue(gsmField.waitForExistence(timeout: 2))
        gsmField.tap()
        
    
        for char in gsm {
            gsmField.typeText(String(char))
            RunLoop.current.run(until: Date().addingTimeInterval(0.1)) // slight delay
        }

        return self
    }

    @discardableResult
    func tapCreateCustomer() -> Self {
        let button = app.buttons["Create Customer"]
        XCTAssertTrue(button.waitForExistence(timeout: 2))
        XCTAssertTrue(button.isEnabled, "Create Customer button should be enabled")
        XCTAssertTrue(button.exists)
        button.tap()
        return self
    }

    @discardableResult
    func assertUserExists(_ fullName: String) -> Self {
        let nameText = app.staticTexts[fullName]
        XCTAssertTrue(nameText.waitForExistence(timeout: 5), "User \(fullName) was not found")
        return self
    }

    @discardableResult
    func addCard(number: String) -> Self {
        let field = app.textFields["16-digit card number"]
        field.tap()
        field.typeText(number)

        let addButton = app.buttons["Add Card"]
        XCTAssertTrue(addButton.isEnabled)
        addButton.tap()
        return self
    }

    @discardableResult
    func assertCardExists(_ formattedNumber: String) -> Self {
        let cardNumber = app.staticTexts[formattedNumber]
        XCTAssertTrue(cardNumber.waitForExistence(timeout: 5), "Card number \(formattedNumber) not found")
        return self
    }
}

