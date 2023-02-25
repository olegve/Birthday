import Foundation


extension NSNotification {
    static let UserData = Notification.Name.init("UserLogs")
}


class Notify{
    func start(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contactStoreDidChange),
            name: .CNContactStoreDidChange,
            object: nil)
    }

    
    @objc func contactStoreDidChange(notification: NSNotification) {
    
    }

    
}

