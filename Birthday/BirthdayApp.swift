import SwiftUI
import Combine
import Contacts

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
        if isPreview {
            sharedModel.contacts = dataSet1
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(presentedContacts: $presentedContacts)
                .environmentObject(sharedModel)
                .onOpenURL{ url in
                    guard url.scheme == "widget-deeplink-contact" else { return }
                    let trimCount = "widget-deeplink-contact://".count
                    let contact_id = url.description.dropFirst(trimCount)
                    #if DEBUG
                    print("id контакта: \(contact_id)")
                    #endif
                    let contact = sharedModel.contacts.first{ contact in contact.identifier == contact_id }
                    guard let contact else { return }
                    presentedContacts.append(contact)
                }
        }
        .onChange(of: scenePhase){ phase in
            if phase == .active && !isPreview {
                sharedModel.updateSync()
            }
            
//            switch phase {
//            case .active:
//                print("A'm ative")
//                if !isPreview {
//                    sharedModel.update()
//                }
//            case .background:
//                print("A'm in background")
//            case .inactive:
//                print("A'm inactive")
//            @unknown default:
//                print("Oh - interesting: I received an unexpected new value.")
//            }
            
        } // .onChange()
    }
}

