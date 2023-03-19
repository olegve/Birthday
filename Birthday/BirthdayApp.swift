import SwiftUI
import Combine
import Contacts
import ContactsUI

@main
// A App that creates the ContactsModel object,
// and places it into the environment for the
// navigation stack.
struct BirthdayApp: App {
    @StateObject private var sharedModel = ContactsModel.shared
    @Environment(\.isPreview) var isPreview
    @Environment(\.scenePhase) private var scenePhase
    @State private var presentedContacts: [CNContact] = []
        
    init() {
        let _ = tryAccessToContact(store: ContactsModel.shared.contactStore)
    
        //  Только для отладки
        #if DEBUG
        if isPreview {
            sharedModel.contacts = dataSet1
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(presentedContacts: $presentedContacts)
                .environmentObject(sharedModel)
                .onOpenURL{ url in
                    guard url.scheme == "widget-deeplink-contact" else { return }
                    let trimCount = "widget-deeplink-contact://".count
                    let contact_id = url.description.dropFirst(trimCount)
                    
//                    #if DEBUG
//                    print("[onOpenURL] id контакта: \(contact_id), количество контактов в стеке навигации: \(presentedContacts.count)")
//                    for contact in presentedContacts {
//                        print("[onOpenURL] \(contact.familyName) \(contact.givenName)")
//                    }
//                    #endif
//
//                    if presentedContacts.count > 0 {
//                        presentedContacts.removeAll()
//                    }
//
//                    #if DEBUG
//                    print("[onOpenURL] Количество контактов в стеке навигации после первого обновления стека: \(presentedContacts.count)")
//                    for contact in presentedContacts {
//                        print("[onOpenURL] \(contact.familyName) \(contact.givenName)")
//                    }
//                    #endif

                    let contact = sharedModel.contacts.first{ $0.identifier == contact_id }
                    guard let contact  else { return }
                    presentedContacts = [contact]
                    
//                    #if DEBUG
//                    print("[onOpenURL] Количество контактов в стеке навигации после второго обновления стека: \(presentedContacts.count)")
//                    for contact in presentedContacts {
//                        print("[onOpenURL] \(contact.familyName) \(contact.givenName)")
//                    }
//                    #endif
                }
        }
        .onChange(of: scenePhase){ phase in
            switch phase {
            case .active:
                #if DEBUG
                print("A'm ative")
                #endif
                if !isPreview {
                    sharedModel.updateSync()
                }
            case .background:
                #if DEBUG
                print("A'm in background")
                #endif
                presentedContacts = []
            case .inactive:
                #if DEBUG
                print("A'm inactive")
                #endif
            @unknown default:
                #if DEBUG
                print("Oh - interesting: I received an unexpected new value.")
                #endif
            }
            
        } // .onChange()
    }
}

