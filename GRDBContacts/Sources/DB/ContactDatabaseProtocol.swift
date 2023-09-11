//
//  ContactDatabaseProtocol.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 9/2/23.
//

import GRDB

protocol ContactDatabaseProtocol {
    var databaseQueue: DatabaseWriter? { get }
    
    // MARK: Connection
    func open() throws
    func migration() throws
    func close()
    
    // MARK: CRUD
    func fetchAllContacts() throws -> [Contact]
    func fetchAllFavoriteContacts() throws -> [Contact]
    func fetchContacts(with name: String) throws -> [Contact]
    func add(_ contact: Contact) throws
    func update(_ contact: Contact, isFavorite: Bool) throws
    @discardableResult
    func delete(_ contact: Contact) throws -> Bool
}

extension ContactDatabaseProtocol {
    // MARK: Fetch Data
    func fetchAllContacts() throws -> [Contact] {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        return try databaseQueue.read { db in
            try Contact.fetchAll(db)
        }
    }
    
    func fetchAllFavoriteContacts() throws -> [Contact] {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        return try databaseQueue.read { db in
            try Contact.filter(Contact.Columns.isFavorite == true).fetchAll(db)
        }
    }
    
    func fetchContacts(with name: String) throws-> [Contact] {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        return try databaseQueue.read { db in
            try Contact.filter(Contact.Columns.name.like("%\(name)%")).fetchAll(db)
        }
    }
    
    // MARK: Add Data
    func add(_ contact: Contact) throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        try databaseQueue.write { db in
            try contact.insert(db)
        }
    }
    
    // MARK: Update Data
    func update(_ contact: Contact, isFavorite: Bool) throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        try databaseQueue.write { db in
            contact.isFavorite = isFavorite
            try contact.update(db)
        }
    }
    
    // MARK: Delete Data
    @discardableResult
    func delete(_ contact: Contact) throws -> Bool {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        return try databaseQueue.write { db in
            try contact.delete(db)
        }
    }
}
