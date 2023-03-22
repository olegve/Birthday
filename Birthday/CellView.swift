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


struct SymbolsFontModifier: ViewModifier {
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Apple Symbols", size: UIFont.preferredFont(forTextStyle: style).pointSize)
            .weight(weight))
    }
}


extension View {
    func symbolsFont(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
        self.modifier(SymbolsFontModifier(style: style, weight: weight))
    }
}


struct ContactFullNameView: View {
    var contact: CNContact
    @EnvironmentObject var shared: ContactsModel
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading){
            ContactNameView(contact: contact)
                .fontWeight(.semibold)
                .font(.title3)
                .dynamicTypeSize(..<DynamicTypeSize.xxLarge) // <- RANGE
            HStack{
                Text("\(contact.birthday!.date!.zodiac.description)")
                    .symbolsFont(style: .callout, weight: .light)
                Text("\(contact.birthday!.date!, formatter: Self.dateFormatter)")
                    .padding(.horizontal, 5)
                AgeView(contact: contact, today: shared.now)
                    .padding(.leading, 5)
                    .fontWeight(.semibold)
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
        ///  Код добавлен вместо .onAppear{}
        ///  Осторожно, может быть бесконечный цикл
        DispatchQueue.main.async {
            self.IsBirthdayToday = daysBeforeBirthday == 0
//            print(daysBeforeBirthdayAsString)
        }
        
        return Text(daysBeforeBirthdayAsString)
            .multilineTextAlignment(.trailing)
            .lineLimit(1)
            .font(.title3)
            .fontWeight(.semibold)
            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)    // <- RANGE
///  Решение правильное, но не работает при открывании программы после нажатие на виджет
//            .onAppear{
//                IsBirthdayToday = daysBeforeBirthday == 0
//            }
    }
}


struct CellView: View {
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact
    @State var isBirthdayToday = false
//    @State var color = Color.primary

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
