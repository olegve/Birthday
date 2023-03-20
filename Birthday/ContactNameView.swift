import Contacts
import SwiftUI


struct ContactNameView: View {
    var contact: CNContact
    
    static let contactFormatter: CNContactFormatter = {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        return formatter
    }()
    
    var body: some View {
        Text("\(contact, formatter: Self.contactFormatter)")
            .lineLimit(1)
    }
}

struct ContactNameView_Previews: PreviewProvider {
    static var previews: some View {
        ContactNameView(contact: dataSet1[0])
            .previewDisplayName("Полное имя контакта")
            .environment(\.locale, .init(identifier: "ru"))
    }
}
