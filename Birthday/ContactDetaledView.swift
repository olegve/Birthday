import SwiftUI
import ContactsUI


struct ContactDetaledView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CNContactViewController
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        var localContact: CNContact = contact
        if !contact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            do {
                localContact = try shared.contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            } catch {
                ///TODO:
                ///
            }
        }
        let resultPage = CNContactViewController(for: localContact)
        resultPage.allowsEditing = false
        return resultPage
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


struct ContactDetaledView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetaledView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
    }
}
