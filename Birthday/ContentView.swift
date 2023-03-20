import SwiftUI
import Contacts
import Combine
import WidgetKit


struct ContentView: View {
    @Binding var presentedContacts: [CNContact]
    
    @EnvironmentObject private var shared: ContactsModel
    @State private var queryString = ""
    @State private var isMontlyView = true
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        let contactFormatter = CNContactFormatter()
        contactFormatter.style = .fullName
        
        let searchedContacts = shared.contacts.filter{ contact in
            (contactFormatter.string(from: contact) ?? "???").localizedCaseInsensitiveContains(queryString)
        }
        let usedContacts = queryString.isEmpty ? shared.contacts : searchedContacts
        
        return NavigationStack(path: $presentedContacts){
            VStack{
                ToggleView(isOn: $isMontlyView)
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .background(colorScheme == .light ? LightTheme.background : DarkTheme.background)
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
                    .toolbarBackground(colorScheme == .light ? LightTheme.background : DarkTheme.background)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar{
                        ToolbarItem(placement: .primaryAction){
                            HStack{
                                Text("\(contact.birthday!.date!.zodiac.rawValue)").padding(.trailing, -3)
                                Text(",").padding(.horizontal, -3)
                                Text("62 года")
                            }
                            .foregroundColor(colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground)
                        }
                    }
                
                
            }
//            .toolbarBackground(colorScheme == .light ? LightTheme.background : DarkTheme.background)
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
                background: colorScheme == .light ? LightTheme.background : DarkTheme.background,
                titleColor: colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground,
                tintColor: colorScheme  == .light ? LightTheme.foreground : DarkTheme.foreground
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




