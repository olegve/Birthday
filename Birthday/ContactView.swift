import SwiftUI
import Contacts


struct ThumbnailView: View {
    @Binding var contact: CNContact
    
    var thumbnail: Image {
        if contact.imageDataAvailable {
            return Image(systemName: "globe")
        } else {
            let letters = String([contact.familyName.first, contact.givenName.first].compactMap{$0})
            return Image(uiImage: imageWith(name: letters)!)
        }
    }
    
    var body: some View {
        thumbnail
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .gray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 35)
        nameLabel.text = name
        nameLabel.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


struct ContactNameView: View {
    @Binding var contact: CNContact
    
    var body: some View {
//        let langStr = Locale.current.language.languageCode?.identifier ?? "ru"
//        let preferredLanguage = Bundle.main.preferredLocalizations.first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
//        dateFormatter.locale = .current
//        dateFormatter.locale = Locale(identifier: langStr)
        dateFormatter.locale = .autoupdatingCurrent
//        dateFormatter.locale = Locale(identifier: "ru")
        let birthday = dateFormatter.string(from: contact.birthday!.date!)

        return VStack(alignment: .leading){
            Text("\(contact.familyName) \(contact.givenName) \(contact.middleName)")
                .fontWeight(.semibold)
                .font(.title3)
                .lineLimit(1)
                .dynamicTypeSize(..<DynamicTypeSize.xxLarge) // <- RANGE
            Text(birthday)
                .fontWeight(.light)
                .font(.callout)
                .lineLimit(1)
                .dynamicTypeSize(..<DynamicTypeSize.xSmall) // <- RANGE
        }
    }
}


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}


struct ReminderView: View {
    @Binding var contact: CNContact
    @Binding var today: Date
        
    var body: some View {
        let text = String(contact.birthday!.date!.get(.day))

        return Text(text)
            .multilineTextAlignment(.trailing)
            .lineLimit(1)
            .font(.title3)
            .fontWeight(.semibold)
            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)    // <- RANGE
    }
}


struct ContactView: View {
    @EnvironmentObject var shared: ContactsModel
    @Binding var contact: CNContact
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .center){
                ThumbnailView(contact: $contact)
                ContactNameView(contact: $contact)
                Spacer()
                ReminderView(contact: $contact, today: $shared.now)
            }
        }
        .frame(height: 40.0)
    }
}


struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contact: .constant(ContactsModel.shared.contacts[0]))
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "ru"))
    }
}
