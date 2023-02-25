import Foundation
import SwiftUI
import Contacts


func tryAccessToContact(store: CNContactStore) -> Bool {
    var result: Bool = false
    let authorisationStatus = CNContactStore.authorizationStatus(for: .contacts)
    switch authorisationStatus {
    case .authorized:
        result = true
        print("Authorized!")
    case .denied, .notDetermined:
        print("Denied!")
        store.requestAccess(for: .contacts){ (access, accessError)->Void in
            if access {
                result = true
                print("Get access")
            } else {
                print("Отлуп")
                result = false
            }
        }
    default:
        print("Нет прав")
        result = false
    }
    return result
}



extension EnvironmentValues {
    /// Позволяет определть, выполняется ли программа в XCode SwiftUI Preview режиме.
    /// - Returns: **true**, если в Preview.
    var isPreview: Bool {
        #if DEBUG
            return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
            return false
        #endif
    }
}

