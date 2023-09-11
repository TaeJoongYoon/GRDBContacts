//
//  GRDBContactsApp.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 8/31/23.
//

import SwiftUI

@main
struct GRDBContactsApp: App {
    private var isUnitTest: Bool { ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil }
    private let contactDatabase = ContactDatabase()
    
    init() {
        if !isUnitTest {
            do {
                try contactDatabase.open()
                try contactDatabase.migration()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isUnitTest {
                Text("Unit Test")
            } else {
                ContactListView()
                    .environmentObject(contactDatabase)
            }
            
        }
    }
}
