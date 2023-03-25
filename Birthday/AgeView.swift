import SwiftUI
import Contacts


struct AgeView: View {
    let contact: CNContact
    let today: Date
    let withZodiac: Bool
    
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
        switch (withZodiac, ageString(count: age).count > 0) {
        case (false, false): Text("")
        case (false, true) : Text(ageString(count: age))
        case (true,  false): Text("\(contact.birthday!.date!.zodiac.localizedName)")
        case (true,  true) : Text("\(contact.birthday!.date!.zodiac.localizedName), \(ageString(count: age))")
        }
    }
}


struct AgeView_Previews: PreviewProvider {
    struct Container: View {
        var body: some View {
            VStack {
                AgeView(contact: dataSet1[0], today: Date(), withZodiac: true)
                AgeView(contact: dataSet1[0], today: Date(), withZodiac: false)
            }
        }
    }
    
    
    static var previews: some View {
        Container()
            .environment(\.locale, .init(identifier: "ru"))
            .previewDisplayName("Возраст")
    }
}
