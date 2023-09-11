//
//  GRDBContactsTests+CRUD.swift
//  GRDBContactsTests
//
//  Created by Tae joong Yoon on 9/2/23.
//

import XCTest
@testable import GRDBContacts

extension GRDBContactsTests { 
    func test_fetchAllContacts_contains_when_contact_is_inserted() throws {
        // given
        let contactAlice = Contact(name: "Alice", phoneNumber: "01011110001")
        try fakeDB.add(contactAlice)
        
        // when
        let fetchedAllContacts = try fakeDB.fetchAllContacts()
        
        // then
        XCTAssertTrue(fetchedAllContacts.contains(where: { $0.name == contactAlice.name }))
    }
    
    func test_fetchAllContacts_empty_when_contact_is_not_inserted() throws {
        // given
        // nothing
        
        // when
        let fetchedAllContacts = try fakeDB.fetchAllContacts()
        
        // then
        XCTAssertTrue(fetchedAllContacts.isEmpty)
    }
    
    func test_fetchAllFavoriteContacts_contains_when_contact_is_inserted_and_favorited() throws {
        // given
        let contactAlice = Contact(name: "Alice", phoneNumber: "01011110001")
        contactAlice.isFavorite = true
        try fakeDB.add(contactAlice)
        
        // when
        let fetchedAllFavoriteContacts = try fakeDB.fetchAllFavoriteContacts()
        
        // then
        XCTAssertTrue(fetchedAllFavoriteContacts.contains(where: { $0.name == contactAlice.name }))
    }
    
    func test_fetchAllFavoriteContacts_failed_when_contact_is_inserted_and() throws {
        // given
        let contactAlice = Contact(name: "Alice", phoneNumber: "01011110001")
        try fakeDB.add(contactAlice)
        
        // when
        let fetchedAllFavoriteContacts = try fakeDB.fetchAllFavoriteContacts()
        
        // then
        XCTExpectFailure {
            XCTAssertTrue(fetchedAllFavoriteContacts.contains(where: { $0.name == contactAlice.name }))
        }
    }
    
    func test_fetchAllFavoriteContacts_empty_when_contact_is_not_inserted() throws {
        // given
        // nothing
        
        // when
        let fetchedAllFavoriteContacts = try fakeDB.fetchAllFavoriteContacts()
        
        // then
        XCTAssertTrue(fetchedAllFavoriteContacts.isEmpty)
    }
    
    func test_fetchContactWithName_found_when_name_contained() throws {
        // given
        let contactAlice = Contact(name: "Alice", phoneNumber: "01011110001")
        try fakeDB.add(contactAlice)
        
        // when
        let fetchedContacts = try fakeDB.fetchContacts(with: "a")
        
        // then
        XCTAssertTrue(!fetchedContacts.isEmpty)
    }
    
    func test_fetchContactWithName_empty_when_name_not_contained() throws {
        // given
        let contactAlice = Contact(name: "Alice", phoneNumber: "01011110001")
        try fakeDB.add(contactAlice)
        
        // when
        let fetchedContacts = try fakeDB.fetchContacts(with: "b")
        
        // then
        XCTAssertTrue(fetchedContacts.isEmpty)
    }
}
