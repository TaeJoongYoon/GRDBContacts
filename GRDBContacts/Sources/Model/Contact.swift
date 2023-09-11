//
//  Contact.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 8/31/23.
//

import GRDB

final class Contact: Record, CustomStringConvertible, Equatable {
    
    // The table name
    override class var databaseTableName: String { "Contact" }
    
    // The table columns
    enum Columns: String, ColumnExpression {
        case id, name, phoneNumber, isFavorite
    }
    
    // Properties
    private(set) var id: Int64!
    let name: String
    let phoneNumber: String
    var isFavorite: Bool
    
    var description: String {
        """
        
        [Contact]
        id:\(id!)
        name:\(name)
        phoneNumber:\(phoneNumber)
        isFavorite:\(isFavorite)
        """
    }
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.isFavorite = false
        super.init()
    }
    
    // Decode from a database row
    required init(row: Row) throws {
        id = row[Columns.id]
        name = row[Columns.name]
        phoneNumber = row[Columns.phoneNumber]
        isFavorite = row[Columns.isFavorite]
        try super.init(row: row)
    }
    
    // The Values persisted in the database
    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.phoneNumber] = phoneNumber
        container[Columns.isFavorite] = isFavorite
    }
    
    // For AUTOINCREMENT
    override func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
    
    // Equatable
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
