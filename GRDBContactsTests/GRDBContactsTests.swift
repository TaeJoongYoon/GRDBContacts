//
//  GRDBContactsTests.swift
//  GRDBContactsTests
//
//  Created by Tae joong Yoon on 8/31/23.
//

import XCTest
@testable import GRDBContacts

final class GRDBContactsTests: XCTestCase {
    let fakeDB = FakeContactDatabase()

    override func setUpWithError() throws {
        try super.setUpWithError()
        try fakeDB.open()
    }

    override func tearDownWithError() throws {
        fakeDB.close()
        try super.tearDownWithError()
    }
}
