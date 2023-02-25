import Foundation
import Contacts
import SwiftUI
import os

extension CNContact: Identifiable {
    public var id: String { self.identifier }
}


extension CNContact {
    override open var description: String { "\(familyName) \(givenName) \(middleName), \(String(describing: birthday!.date!))" }
}


extension Array where Element == CNContact {
    func birthdaysThis(month: Month) -> [CNContact] {
        self.filter{ contact in (contact.birthday?.month ?? 0) == month.id }
    }
}


@MainActor
final class ContactsModel: ObservableObject {
    static let shared = ContactsModel()
    @Published var contacts: [CNContact]
    @Published var now: Date = Date()
    let contactStore = CNContactStore()
    
    private static let logger = Logger(
           subsystem: Bundle.main.bundleIdentifier!,
           category: String(describing: ContactsModel.self)
       )
    
    private init() {
        contacts = []
        Self.logger.trace("Программа стартует!")
    }
    
    func update() async -> Void {
        updateSync()
    }

    func updateSync() -> Void {
        updateTodayDate()
        do {
            contacts = try getPersons()
        } catch {
            print("Контакты не загружаются, contacts = []")
            contacts = []
            Self.logger.critical("Контакты не загружаются, contacts = []")
        }
    }

    
    func updateTodayDate() -> Void {
        now = Date()
    }
    
    func birthdaysThis(month: Month) -> [CNContact] {
        contacts.birthdaysThis(month: month)
    }
        
    func getPersons() throws -> [CNContact]{
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStore.defaultContainerIdentifier())
        var contacts: [CNContact]! = []
        
        contacts = try contactStore.unifiedContacts(
            matching: predicate,
            keysToFetch: [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactBirthdayKey as NSString,
                CNContactImageDataKey as NSString,
                CNContactImageDataAvailableKey as NSString,
                CNContactThumbnailImageDataKey as NSString
            ]
        )
        return contacts.filter{ $0.birthday != nil }
    }
}
