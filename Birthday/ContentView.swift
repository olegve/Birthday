import SwiftUI
import Contacts
import Combine
import WidgetKit

struct ToggleView: View {
    @Binding var isOn: Bool
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        if isSearching { SearchHeaderView() }
        else { Toggle(isOn: $isOn){TogglePromptView()} }
    }
}


struct SearchHeaderView: View {
    var body: some View {
        HStack{
            Text("Результат поиска:")
                .foregroundColor(Color.gray)
            Spacer()
        }
    }
}


struct TogglePromptView: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Listed.By.month")
        }
    }
}


struct ContentView: View {
    @EnvironmentObject private var shared: ContactsModel
    @State private var queryString = ""
    @State private var isMontlyView = true
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let contactFormatter = CNContactFormatter()
        contactFormatter.style = .fullName
        
        let searchedContacts = shared.contacts.filter{ contact in
            (contactFormatter.string(from: contact) ?? "???").localizedCaseInsensitiveContains(queryString)
        }
        let usedContacts = queryString.isEmpty ? shared.contacts : searchedContacts
        return NavigationStack{
            VStack{
                ToggleView(isOn: $isMontlyView)
                    .font(.callout)
                    .padding(.horizontal)
                List{
                    if isMontlyView {
                        GroupByMonthView(contacts: usedContacts, thisMonth: shared.now.Month, thisDay: shared.now.day)
                    } else {
                        GroupByDaysView(contacts:  usedContacts)
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("Navigation.Title")
            }
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
        }
    }
}


struct ListTest_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "ru"))
        
        ContentView()
            .environmentObject(ContactsModel.shared)
            .environment(\.locale, .init(identifier: "en"))
    }
}




