//
//  ContactDatabase.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 9/2/23.
//

import Foundation
import GRDB

final class ContactDatabase: ObservableObject, ContactDatabaseProtocol {
    
    // MARK: Properties
    @Published var allContacts: [Contact] = []
    @Published var favoriteContacts: [Contact] = []
    
    private var contactsObservation: AnyDatabaseCancellable?
    private var contactObservation: AnyDatabaseCancellable?
    
    private var path: URL {
        get throws {
            guard let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                throw ContactDatabaseError.invalidURL
            }
            
            return url
        }
    }
    
    var databaseQueue: DatabaseWriter?
    
    // MARK: Open Database
    func open() throws {
        var configuration = Configuration()
        configuration.prepareDatabase { db in
            db.trace { print("SQL: \($0)") }
        }
        
        databaseQueue = try DatabaseQueue(path: "\(path)/database.sqlite", configuration: configuration)
        print(try path)
    }
    
    // MARK: Create Table
    func migration() throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        var migrator = DatabaseMigrator()
//        #if DEBUG
//        migrator.eraseDatabaseOnSchemaChange = true
//        #endif

        // 1st migration
        migrator.registerMigration("Create Table") { db in
            try db.create(table: Contact.databaseTableName, options: .ifNotExists) { t in
                    t.primaryKey(Contact.Columns.id.rawValue, .integer)
                    t.column(Contact.Columns.name.rawValue, .text).notNull()
                    t.column(Contact.Columns.phoneNumber.rawValue, .text).notNull()
                    t.column(Contact.Columns.isFavorite.rawValue, .boolean).notNull().defaults(to: false)
                }
        }
        
        // 2nd migration
        migrator.registerMigration("Add Note") { db in
            try db.alter(table: Contact.databaseTableName) { t in
                t.add(column: "note", .text)
            }
        }
        
        try migrator.migrate(databaseQueue)
        try observeAllContacts()
    }
    
    // MARK: Close Database
    func close() {
        databaseQueue = nil
    }
    
    // MARK: ValueObservation
    func observeAllContacts() throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        contactsObservation = ValueObservation.tracking { db in
            try Contact.fetchAll(db) // Fetch For Observation
        }
        .print() // Trace observation events
        .start(in: databaseQueue) { error in
            // handle error
        } onChange: { contacts in
            // observed contacts
        }
        
        contactObservation = ValueObservation.tracking { db in
            try Contact.fetchOne(db) // Fetch For Observation
        }
        .start(in: databaseQueue) { error in
            // handle error
        } onChange: { contact in
            // observed contact
        }
    }
    
    // MARK: Swift Concurrency
    func fetch() async throws -> [Contact] {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        return try await databaseQueue.read { db in
            try Contact.fetchAll(db)
        }
    }
    
    func insert(_ contact: Contact) async throws {
        guard let databaseQueue else { throw ContactDatabaseError.notOpened }
        
        try await databaseQueue.write { db in
            try contact.insert(db)
        }
    }
}

