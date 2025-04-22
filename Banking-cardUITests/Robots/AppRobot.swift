//
//  AppRobot.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//
import XCTest

struct AppRobot {
    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func launch() -> Self {
        app.launch()
        return self
    }
    @discardableResult
    func home(_ closure: (HomeRobot) -> HomeRobot) -> Self {
        _ = closure(HomeRobot(app: app))
        return self
    }
}
