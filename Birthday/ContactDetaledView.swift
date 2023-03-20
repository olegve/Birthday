import SwiftUI
import ContactsUI


// TODO: [PPT] Error creating the CFMessagePort needed to communicate with PPT.
struct ContactDetaledView: UIViewControllerRepresentable {
    //    typealias UIViewControllerType = CNContactViewController
    #if DEBUG
    typealias UIViewControllerType = UINavigationController //UIViewController
    @Environment(\.isPreview) var isPreview
    #else
    typealias UIViewControllerType = UINavigationController
    #endif
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact

    // MARK: ViewController Representable delegate methods
    func makeCoordinator() -> ContactDetaledView.Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ContactDetaledView>) -> UIViewControllerType {
        var localContact: CNContact = context.coordinator.parent.contact
//        print("[1: makeUIViewController] DetailedView for: \(contact.familyName) \(contact.givenName)")
//        print("[2: makeUIViewController] DetailedView for cotext: \(localContact.familyName) \(localContact.givenName)")
        if !localContact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            do {
                localContact = try shared.contactStore.unifiedContact(withIdentifier: localContact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            } catch {
                ///TODO:
                ///
                print("Truble!")
            }
        }
        let controller = CNContactViewController(for: localContact)
        controller.allowsEditing = false
        controller.allowsActions = true
        controller.delegate = context.coordinator
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ContactDetaledView>) {
//        #if DEBUG
//        let contextContact = context.coordinator.parent.contact
//        print("[1: updateUIViewController] UIViewController updated. \(contextContact.familyName) \(contextContact.givenName)")
//        let controllerContact = self.contact
//        print("[2: updateUIViewController] UIViewController updated. \(controllerContact.familyName) \(controllerContact.givenName)")
//        #endif
        context.coordinator.parent.contact = self.contact
//        guard let top = uiViewController.topViewController else { return }
//        guard let cc = top as? CNContactViewController else { return }
//        print("[CNContactViewController] \(cc.contact.familyName)")
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, CNContactViewControllerDelegate {
        var parent: ContactDetaledView
        init(_ contactDetail: ContactDetaledView) {
            self.parent = contactDetail
//            print("[COORDINATOR] Create coordinator for \(parent.contact.familyName) \(parent.contact.givenName) ContactDetaledView")
        }
        
        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {}
        func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool { true }
    }
}


struct ContactDetaledView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetaledView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
            .environment(\.colorScheme, .light)
            .previewDisplayName("Светлая тема")
        
        ContactDetaledView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Тёмная тема")

    }
}
