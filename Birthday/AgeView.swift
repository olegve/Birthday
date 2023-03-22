import SwiftUI
import Contacts

struct AgeView: View {
    let contact: CNContact
    let today: Date
    var age: Int {
        let age = today.year - contact.birthday!.year!
        let cbMonth = contact.birthday!.month!
        let cbDay = contact.birthday!.day!
        let tMonth = today.month
        let tDay = today.day
        
        var delta = 0
        
        return age + delta
    }
    
    var body: some View {
        Text("\(age) года")
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView(contact: dataSet1[0], today: Date())
    }
}
