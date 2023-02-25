import SwiftUI
import Contacts


struct ThumbnailView: View {
    var contact: CNContact
    
    var letters: String {
        let cherecters = CNContactFormatter.nameOrder(for: contact) == .givenNameFirst ? [contact.givenName.first, contact.familyName.first] : [contact.familyName.first, contact.givenName.first]
        return String(cherecters.compactMap{ $0 })
    }
    
    var thumbnail: Image {
        let image = contact.imageDataAvailable ? UIImage(data: contact.thumbnailImageData!) : imageWith(name: letters)
        return Image(uiImage: image!)
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


struct ContactFullNameView: View {
    var contact: CNContact
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    static let contactFormatter: CNContactFormatter = {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading){
            Text("\(contact, formatter: Self.contactFormatter)")
                .fontWeight(.semibold)
                .font(.title3)
                .lineLimit(1)
                .dynamicTypeSize(..<DynamicTypeSize.xxLarge) // <- RANGE
            HStack{
                Text("\(contact.birthday!.date!, formatter: Self.dateFormatter)")
                    .padding(.trailing)
//                Text("58 лет,")
//                Text("Водолей")
            }
            .fontWeight(.light)
            .font(.callout)
            .lineLimit(1)
            .dynamicTypeSize(..<DynamicTypeSize.xSmall) // <- RANGE
        }
    }
}


struct ReminderView: View {
    var contact: CNContact
    @Binding var today: Date
    @Binding var IsBirthdayToday: Bool
        
    var body: some View {
        let daysBeforeBirthday = today.days(until: contact.birthday!.date!)
        let daysBeforeBirthdayAsString = "\(daysBeforeBirthday)"

        return Text(daysBeforeBirthdayAsString)
            .multilineTextAlignment(.trailing)
            .lineLimit(1)
            .font(.title3)
            .fontWeight(.semibold)
            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)    // <- RANGE
            .onAppear{
                IsBirthdayToday = daysBeforeBirthday == 0
            }
    }
}


struct CellView: View {
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact
    @State var isBirthdayToday = false
    @State var color = Color.primary

    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .center){
                ThumbnailView(contact: contact)
                ContactFullNameView(contact: contact)
                Spacer()
                ReminderView(contact: contact, today: $shared.now, IsBirthdayToday: $isBirthdayToday)
            }
            .foregroundColor(isBirthdayToday ? .red : .primary)
        }
        .frame(height: 40.0)
    }
}


struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "ru"))
    }
}
