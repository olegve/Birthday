import SwiftUI
import ContactsUI


// TODO: [PPT] Error creating the CFMessagePort needed to communicate with PPT.
struct ContactDetaledView: UIViewControllerRepresentable {
    //    typealias UIViewControllerType = CNContactViewController
    #if DEBUG
    typealias UIViewControllerType = UIViewController
    @Environment(\.isPreview) var isPreview
    #else
    typealias UIViewControllerType = UINavigationController
    #endif
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact

    // MARK: ViewController Representable delegate methods
    func makeCoordinator() -> ContactDetaledView.Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ContactDetaledView>) -> UIViewControllerType {
        var localContact: CNContact = contact
        if !contact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            do {
                localContact = try shared.contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            } catch {
                ///TODO:
                ///
            }
        }
        let controller = CNContactViewController(for: localContact)
        controller.allowsEditing = false
        controller.allowsActions = true
        #if DEBUG
        guard !isPreview else { return controller }
        #endif
        controller.delegate = context.coordinator
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ContactDetaledView>) {
        #if DEBUG
        let contact = context.coordinator.parent.contact
        print("UIViewController updated. \(contact.familyName) \(contact.givenName)")
        #endif
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, CNContactViewControllerDelegate {
        var parent: ContactDetaledView
        init(_ contactDetail: ContactDetaledView) { self.parent = contactDetail }
        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {}
        func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool { true }
    }
}


struct ContactDetaledView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetaledView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
    }
}
