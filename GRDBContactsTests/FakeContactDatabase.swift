//
//  FakeContactDatabase.swift
//  GRDBContactsTests
//
//  Created by Tae joong Yoon on 9/2/23.
//

import GRDB
@testable import GRDBContacts

final class FakeContactDatabase: ContactDatabaseProtocol {
    var databaseQueue: DatabaseWriter?
    
    func open() throws {
        databaseQueue = try DatabaseQueue()
        try migration()
    }
    
    func migration() throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        try databaseQueue.write { db in
            try db.create(table: Contact.databaseTableName, options: .ifNotExists) { t in
                t.primaryKey(Contact.Columns.id.rawValue, .integer)
                t.column(Contact.Columns.name.rawValue, .text).notNull()
                t.column(Contact.Columns.phoneNumber.rawValue, .text).notNull()
                t.column(Contact.Columns.isFavorite.rawValue, .boolean).notNull().defaults(to: false)
            }
        }
    }
    
    func close() {
        databaseQueue = nil
    }
    
}
