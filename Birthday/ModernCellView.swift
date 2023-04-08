import SwiftUI
import Contacts


/// Фотография контакта, если она есть, иначе его инициалы
fileprivate struct ThumbnailView: View {
    var contact: CNContact
    @Binding var isBirthdayToday: Bool
    let diameter: Double
    
    var letters: String {
        let charecters = CNContactFormatter.nameOrder(for: contact) == .givenNameFirst ? [contact.givenName.first, contact.familyName.first] : [contact.familyName.first, contact.givenName.first]
        return String(charecters.compactMap{ $0 })
    }
    
    var imageAvailable: Bool { contact.imageDataAvailable }
    
    func image(avalible: Bool) -> Image? {
        guard avalible else { return nil }
        return Image(uiImage: UIImage(data: contact.thumbnailImageData!)!).resizable()
    }
    
    func letters(avalible: Bool) -> Text? {
        guard avalible else { return nil }
        return  Text(letters)
    }
    
    var body: some View {
        VStack {
            image(avalible: imageAvailable)
            letters(avalible: !imageAvailable)
                .frame(width: diameter,  height: diameter)
                .font(.system(size: diameter * 0.44, weight: .bold, design: .none))
                .background(contentBackground)
                .foregroundColor(contentForeground)
        }
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(isBirthdayToday ? contentTintBackground : titleBackground, lineWidth: 1)
            )
    }
}


fileprivate struct SymbolsFontModifier: ViewModifier {
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Apple Symbols", size: UIFont.preferredFont(forTextStyle: style).pointSize)
            .weight(weight))
    }
}


fileprivate extension View {
    func symbolsFont(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
        self.modifier(SymbolsFontModifier(style: style, weight: weight))
    }
}


fileprivate struct ContactFullNameView: View {
    var contact: CNContact
    @EnvironmentObject var shared: ContactsModel
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMMMYYYY")
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    
    private func formatter(_ template: String = "ddMMMMYYYY") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(template)
        formatter.locale = .autoupdatingCurrent
        return formatter
    }

    var birthday: String {
        let template = contact.birthday?.year == nil ? "dMMMM" : "dMMMMYYYY"
        return formatter(template).string(from: contact.birthday!.date!)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            ContactNameView(contact: contact)
                .fontWeight(.semibold)
                .font(.title3)
                .dynamicTypeSize(..<DynamicTypeSize.xxLarge) // <- RANGE
            HStack{
                Text("\(contact.birthday!.date!.zodiac.description)")
                    .symbolsFont(style: .callout, weight: .light)
                Text(birthday) //   Text("\(contact.birthday!.date!, formatter: Self.dateFormatter)")
//                    .padding(.horizontal, 5)
                AgeView(contact: contact, today: shared.now, withZodiac: false)
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


fileprivate struct ReminderView: View {
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
        }
        return (IsBirthdayToday ? Text(Image(systemName: "birthday.cake")) : Text(daysBeforeBirthdayAsString))
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


struct ModernCellView: View {
    @EnvironmentObject var shared: ContactsModel
    var contact: CNContact
    @State var isBirthdayToday = false
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .center){
                // Фото контакта
                ThumbnailView(contact: contact, isBirthdayToday: $isBirthdayToday, diameter: geometry.size.height)
                // Полное имя контакта, дата рождения и сеолько ему в этот день исполняется лет
                ContactFullNameView(contact: contact)
                Spacer()
                VStack{
                    // Количество дней до дня рождения
                    ReminderView(contact: contact, today: $shared.now, IsBirthdayToday: $isBirthdayToday)
                        .frame(width: 50, height: geometry.size.height * 0.75)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(contentBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(isBirthdayToday ? contentTintBackground : titleBackground, lineWidth: 1)
                        )
                    //                    .shadow(radius: 3)
                }
            }
            .foregroundColor(isBirthdayToday ? contentTint : contentForeground)
        }
        .frame(height: 40.0)
    }
}


struct ModernCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HStack{
                Text("ДЕ")
                    .frame(width: 80,  height: 80)
                    .font(.system(size: 35, weight: .bold, design: .none))
                    .background(.gray)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.red, lineWidth: 1)
                    )
                Spacer()
            }
            ModernCellView(contact: dataSet1[0])
                .environmentObject(ContactsModel.shared)
                .environment(\.locale, .init(identifier: "ru"))
                .environment(\.colorScheme, .light)
                .previewDisplayName("Светлая тема")
                .background(contentBackground)
        }
        
        ModernCellView(contact: dataSet1[0])
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "en"))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Тёмная тема")
            .background(contentBackground)
    }
}
