import SwiftUI
import Contacts


struct SectionView: View {
    let sectionHeader: String
    let contacts: [CNContact]
    @EnvironmentObject var shared: ContactsModel
    
    var body: some View {
        let now = shared.now
        let sortedContacts = contacts
            .sorted{ now.days(until: $0.birthday!.date!) < now.days(until: $1.birthday!.date!) }
        
        return Section(header: Text(sectionHeader)){
            ForEach(sortedContacts){ contact in
                NavigationLink(value: contact){ CellView(contact: contact) }
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
