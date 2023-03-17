import SwiftUI
import ContactsUI


// TODO: [PPT] Error creating the CFMessagePort needed to communicate with PPT.
struct ContactDetaledView: UIViewControllerRepresentable {
    //    typealias UIViewControllerType = CNContactViewController
    typealias UIViewControllerType = UINavigationController
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
        
        controller.delegate = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ContactDetaledView>) {
        #if DEBUG
        print("UIViewController updated. \(context.coordinator.parent.contact.familyName)")
        
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
