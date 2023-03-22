import SwiftUI
import Contacts

struct AgeView: View {
    let contact: CNContact
    let today: Date

    var age: Int! {
        guard let cbYear  = contact.birthday!.year else { return nil }
        guard let cbMonth = contact.birthday!.month else { return nil }
        guard let cbDay   = contact.birthday!.day else { return nil }
        
        let age = today.year - cbYear

        let tMonth = today.month
        let tDay = today.day
        
        let delta = tMonth < cbMonth ? 0 : (tMonth > cbMonth ? 1 : (tDay <= cbDay ? 0 : 1) )
        return age + delta
    }
    
    var body: some View {
        Text(age != nil ? "\(age!) года" : "")
        Text("\(age) года")
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView(contact: dataSet1[0], today: Date())
    }
}
