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
        return !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var isNumberValid: Bool {
        let cleanedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Regular expression for basic phone number formats (e.g., 1234567890, (123) 456-7890, +11234567890)
        let phoneRegex = "^[0-9+()\\s-]{7,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: cleanedNumber)
    }
    
    var isFormValid: Bool {
        return isNameValid && isNumberValid
    }
    
    func saveContact(completion: @escaping (Result<Void, Error>) -> Void) {
        let contact = Contact(name: name, phoneNumber: number)
        DataPersistenceManager.shared.saveContact(model: contact, completion: completion)
    }
    
    func updateContact(item: ContactItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let contact = Contact(name: name, phoneNumber: number)
        DataPersistenceManager.shared.updateContact(item: item, model: contact, completion: completion)
    }
}
