//
//  HomeViewModelTestCaseSpecs.swift
//  Banking-card
//
//  Created by Kamran on 22.04.25.
//

protocol HomeViewModelSpecs {
    func testCreateUser() async throws
    func testCreateCard() async throws
    func testSuccessfulTransfer() async throws
    func testTransferInsufficientBalance() async throws
    func testEmptyAmountTransfer() async throws
    func testInvalidAmountTransfer() async throws
    func testTransferBetweenDifferentUsers() async throws
    func testRemoveCard() async throws
    
}
