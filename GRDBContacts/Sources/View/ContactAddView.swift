//
//  ContactAddView.swift
//  GRDBContacts
//
//  Created by Tae joong Yoon on 9/1/23.
//

import SwiftUI

struct ContactAddView: View {
    @EnvironmentObject var contactDatabase: ContactDatabase
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    private let navigationTitle: String = "New Contact"
    
    var body: some View {
        NavigationStack {
            List {
                nameTextField
                phoneNumberTextField
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { cancelNavigtionButton }
            .toolbar { doneNavigtionButton }
        }
    }
    
    private var nameTextField: some View {
        TextField("name", text: $name)
            .keyboardType(.namePhonePad)
            .disableAutocorrection(true)
    }
    
    private var phoneNumberTextField: some View {
        TextField("phone number", text: $phoneNumber)
            .keyboardType(.phonePad)
    }
    
    private var cancelNavigtionButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var doneNavigtionButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                let contact = Contact(name: name, phoneNumber: phoneNumber)
                do {
                    try contactDatabase.add(contact)
                } catch {
                    print("Error: \(error)")
                }
                dismiss()
            } label: {
                Text("Done").bold()
            }
            .disabled(name.isEmpty || phoneNumber.isEmpty)
        }
    }
}
