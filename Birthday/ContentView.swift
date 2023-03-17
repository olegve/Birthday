import SwiftUI
import Contacts
import Combine
import WidgetKit


struct CheckmarkToggleStyle: ToggleStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ?
                    colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground
                    :
                    (colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground).opacity(0.5)
                )
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(colorScheme == .light ? LightTheme.background : DarkTheme.background)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ?
                                    colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground
                                    :
                                    (colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground).opacity(0.5)
                                )
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(.linear(duration: 0.1), value: configuration.isOn)
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}


struct ToggleView: View {
    @Binding var isOn: Bool
    @Environment(\.isSearching) private var isSearching
    let transition = AnyTransition
        .asymmetric(insertion: .slide, removal: .scale)
        .combined(with: .opacity)
    
    var body: some View {
        HStack{
            if isSearching {
                SearchHeaderView().transition(transition)
            } else {
                Toggle(isOn: $isOn){ TogglePromptView() }
                    .transition(transition)
                    .toggleStyle(CheckmarkToggleStyle())
            }
        }
        .animation(.default.speed(1), value: isSearching)
    }
}


struct SearchHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack{
            Text("Результат поиска:")
                .foregroundColor(colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground)
            Spacer()
        }
    }
}


struct TogglePromptView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack{
            Spacer()
            Text("Listed.By.month")
        }
        .foregroundColor(colorScheme == .light ? LightTheme.foreground : DarkTheme.foreground)
    }
}


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
                    .navigationBarTitle("", displayMode: .inline)
                    /// Это тоже двигает вверх ContactDetaledView ещё чуть-чуть
                    .edgesIgnoringSafeArea(.top)
//                    .toolbarBackground(colorScheme == .light ? LightTheme.background : DarkTheme.background)
//                    .toolbarBackground(.visible, for: .navigationBar)
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
        ContentView(presentedContacts: .constant([]))
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "ru"))
        
        ContentView(presentedContacts: .constant([]))
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "en"))
            .environment(\.colorScheme, .dark)
    }
}




