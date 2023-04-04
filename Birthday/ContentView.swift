import SwiftUI
import Contacts
import Combine
import WidgetKit


struct NavigationBackButton: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    var color: Color
    var text: String?

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: { presentationMode.wrappedValue.dismiss() }){
                    HStack(spacing: 2){
                        Image(systemName: "chevron.backward")
                        if let text {
                            Text(text)
                        }
                    }
                    .foregroundColor(color)
                }   // Button
            )       // .navigationBarItems
    }
}


extension View {
    func navigationBackButton(color: Color, text: String? = nil) -> some View {
        modifier(NavigationBackButton(color: color, text: text))
    }
}


struct ContentView: View {
    @Binding var presentedContacts: [CNContact]
    
    @EnvironmentObject private var shared: ContactsModel
    @State private var queryString = ""
    @State private var isMontlyView = true
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
//    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        let contactFormatter = CNContactFormatter()
        contactFormatter.style = .fullName
        
        let searchedContacts = shared.contacts.filter{ contact in
            (contactFormatter.string(from: contact) ?? "???").localizedCaseInsensitiveContains(queryString)
        }
        let usedContacts = queryString.isEmpty ? shared.contacts : searchedContacts
        
        return NavigationStack(path: $presentedContacts){
            VStack(spacing: 0){
                ToggleView(isOn: $isMontlyView)
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .background(titleBackground)
                List{
                    if isMontlyView {
                        GroupByMonthView(contacts: usedContacts, thisMonth: shared.now.Month, thisDay: shared.now.day)
                    } else {
                        GroupByDaysView(contacts:  usedContacts)
                    }
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Navigation.Title")
            .navigationDestination(for: CNContact.self){ contact in
                ContactDetaledView(contact: contact)
                    /// Такой navigationBarTitle двигает вверх ContactDetaledView
//                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarTitleDisplayMode(.inline)
                    /// Это тоже двигает вверх ContactDetaledView ещё чуть-чуть
                    .edgesIgnoringSafeArea(.top)
                    .toolbarBackground(titleBackground, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar{
                        ToolbarItem(placement: .primaryAction){
                            AgeView(contact: contact, today: shared.now, withZodiac: true)
                                .foregroundColor(titleForeground)
                        }
                    }
                    .navigationBackButton(
                        color: titleForeground,
                        text: String(localized: "Navigation.Title")
                    )
                    .tint(titleForeground)
            }
//            .toolbarBackground(titleBackground)
//            .toolbarBackground(.visible, for: .navigationBar)
        }  // NavigationStack
        .searchable(text: $queryString, prompt: "Фамилия, имя или отчество")
        .onReceive(NotificationCenter.default.publisher(for: .CNContactStoreDidChange)){ _ in
            // В Контактах произошли изменения
            shared.updateSync()
            WidgetCenter.shared.reloadTimelines(ofKind: "BirthdayWidget")
        }
        .onReceive(timer){ newDate in
            guard newDate.day != shared.now.day else { return }
            // Наступили новые сутки
            shared.updateTodayDate()
        }
        .onAppear(){
            // Просто обновляем виджет на всякий случай
            WidgetCenter.shared.reloadTimelines(ofKind: "BirthdayWidget")
            // Устанавливаем тему
            Theme.navigationBarColors(
                background: titleBackground,
                titleColor: titleForeground,
                tintColor:  titleForeground
            )
        }
    }
}


struct ListTest_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            ContentView(presentedContacts: .constant([]))
        }
        .environmentObject(ContactsModel.shared)
        .environment(\.locale, .init(identifier: "ru"))
        .environment(\.colorScheme, .light)
        .previewDisplayName("Светлая тема")
        
        ZStack{
            ContentView(presentedContacts: .constant([]))
        }
        .environmentObject(ContactsModel.shared)
        .environment(\.locale, .init(identifier: "en"))
        .environment(\.colorScheme, .dark)
        .previewDisplayName("Тёмная тема")
    }
}




