//
//  ContactFormViewModel.swift
//  SimpleContacts
//
//  Created by Hasitha Chamupathi on 2025-05-20.
//

import Foundation

class ContactFormViewModel {
    var name: String = ""
    var number: String = ""
       
    var isNameValid: Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty && name.count >= 3
    }
    
    var isNumberValid: Bool {
        return !number.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isFormValid: Bool {
        return isNameValid && isNumberValid
    }
    
    func saveContact(completion: @escaping (Result<Void, Error>) -> Void) {
        let contact = Contact(name: name, phoneNumber: number)
        DataPersistenceManager.shared.saveContact(model: contact, completion: completion)
    }
}
