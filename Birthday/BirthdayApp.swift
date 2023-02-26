import SwiftUI
import Combine

@main
// A App that creates the ContactsModel object,
// and places it into the environment for the
// navigation stack.
struct BirthdayApp: App {
    @StateObject private var sharedModel = ContactsModel.shared
    @Environment(\.isPreview) var isPreview
    @Environment(\.scenePhase) private var scenePhase
    
    
    init() {
        let _ = tryAccessToContact(store: ContactsModel.shared.contactStore)
    
        //  Только для отладки
        if isPreview {
            sharedModel.contacts = dataSet1
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ExampleContentView()
//            ContentView()
                .environmentObject(sharedModel)
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
            
        }
    }
}

