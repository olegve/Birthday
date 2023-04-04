import SwiftUI
import Contacts


struct SectionView: View {
    let sectionHeader: String
    let contacts: [CNContact]
    @EnvironmentObject var shared: ContactsModel
    @Environment(\.colorScheme) var colorScheme
    let contactFormatter: CNContactFormatter = {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        return formatter
    }()
    
    var body: some View {
        let now = shared.now
        let sortedContacts = contacts
            .sorted{ lhs, rhs in
                let lhsDay = now.days(until: lhs.birthday!.date!)
                let rhsDay = now.days(until: rhs.birthday!.date!)
                guard lhsDay == rhsDay else { return lhsDay < rhsDay }
                return contactFormatter.string(from: lhs)! < contactFormatter.string(from: rhs)!
            }
        
        return Section(header: Text(sectionHeader)){
            ForEach(sortedContacts){ contact in
                ZStack {
                    ModernCellView(contact: contact)
                    NavigationLink(value: contact) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
//                    ModernCellView(contact: contact)
                }
//                NavigationLink(value: contact){ ModernCellView(contact: contact) }

//                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
//                        Button {
//                            print("Звоним на мобильный телефон.")
//                        } label: {
//                            Label("Звонок", systemImage: "phone.fill.arrow.up.right")
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle(.red, .white)
//                        }
//                        .tint(.indigo)
//                    }  // swipeAction
            }  // ForEach
        }   // Section
        .foregroundColor(sectionForeground)
        .listRowBackground(contentBackground)
        .listRowSeparatorTint(contentSeparator)
    }
}


struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        let month = Month.feb
        let header = month.description
        let contacts = ContactsModel.shared.contacts.birthdaysThis(month: month)
        
        return NavigationView{
            List{
                SectionView(sectionHeader: header, contacts: contacts)
                    .environmentObject(ContactsModel.shared)
            }
        }
    }
}
