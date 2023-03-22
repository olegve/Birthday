import SwiftUI
import Contacts


struct AgeView: View {
    let contact: CNContact
    let today: Date
    
    var age: Int? {
        guard let b = contact.birthday, let cbYear = b.year, let cbMonth = b.month, let cbDay = b.day else { return nil }
        let delta = today.month < cbMonth ? 0 : ( today.month > cbMonth ? 1 : (today.day <= cbDay ? 0 : 1) )
        return (today.year - cbYear) + delta
    }
    
    private func ageString(count: Int?) -> String {
        guard let count else { return "" }
        let formatString = NSLocalizedString("ages.count", comment: "")
        let resultString = String(format: formatString, count)
        return resultString
    }
    
    
    var body: some View {
        Text(ageString(count: age))
    }
}


struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView(contact: dataSet1[0], today: Date())
            .environment(\.locale, .init(identifier: "ru"))
    }
}
