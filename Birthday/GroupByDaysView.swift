import Contacts
import SwiftUI

struct GroupByDaysView: View {
    let contacts: [CNContact]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GroupByDaysView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            List{
                GroupByDaysView(contacts: ContactsModel.shared.contacts)
                    .environmentObject(ContactsModel.shared)
            }
        }
    }
}
