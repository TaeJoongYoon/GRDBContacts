//
//  ContactListView.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 8/31/23.
//

import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var contactDatabase: ContactDatabase
    
    @State private var searchingName = ""
    @State private var isSearching = false
    @State private var isPresented: Bool = false
    
    private let navigationTitle: String = "Contacts"
    
    var body: some View {
        NavigationStack {
            List {
                favoriteSection
                defaultSection
            }
            .onAppear(perform: onAppear)
            .navigationTitle(navigationTitle)
            .toolbar { addNavigationButton }
        }
        .searchable(text: $searchingName, isPresented: $isSearching)
        .onChange(of: searchingName) {
            fetch(with: searchingName)
        }
        .sheet(isPresented: $isPresented, onDismiss: onSheetDismiss) {
            ContactAddView()
        }
    }
}

// MARK: - Subview
private extension ContactListView {
    @ViewBuilder
    var favoriteSection: some View {
        let sectionTitle: String = "Favorite"
        
        if contactDatabase.favoriteContacts.isEmpty || !searchingName.isEmpty || isSearching {
            EmptyView()
        } else {
            Section {
                ForEach(contactDatabase.favoriteContacts, id: \.id) { contact in
                    Text(contact.name)
                        .transition(.slide)
                        .swipeActions(edge: .leading) {
                            Button {
                                do {
                                    try contactDatabase.update(contact, isFavorite: false)
                                    fetchAll()
                                } catch {
                                    print("Error: \(error)")
                                }
                            } label: {
                                Label("Set not Favorite", systemImage: "star.slash.fill")
                            }
                            .tint(.indigo)
                        }
                }
            } header: {
                Text(sectionTitle)
            }
        }
    }
    
    @ViewBuilder
    var defaultSection: some View {
        Section {
            ForEach(contactDatabase.allContacts, id: \.id) { contact in
                Text(contact.name)
                    .transition(.slide)
                    .swipeActions(edge: .leading) {
                        Button {
                            do {
                                try contactDatabase.update(contact, isFavorite: !contact.isFavorite)
                                fetchAll()
                            } catch {
                                print("Error: \(error)")
                            }
                        } label: {
                            Label("Set Favorite", systemImage: contact.isFavorite ? "star.slash.fill" : "star.fill")
                        }
                        .tint(.indigo)
                    }
            }
            .onDelete { indexSet in
                if let index = indexSet.first {
                    let contact = contactDatabase.allContacts[index]
                    do {
                        try contactDatabase.delete(contact)
                        fetchAll()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
    
    var addNavigationButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isPresented = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: Action
private extension ContactListView {
    func fetchAll() {
        do {
            fetch(with: searchingName)
            contactDatabase.favoriteContacts = try contactDatabase.fetchAllFavoriteContacts()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func fetch(with name: String) {
        do {
            if name.isEmpty {
                contactDatabase.allContacts = try contactDatabase.fetchAllContacts()
            } else {
                contactDatabase.allContacts = try contactDatabase.fetchContacts(with: name)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func onAppear() {
        fetchAll()
    }
    
    func onSheetDismiss() {
        fetchAll()
    }
}
