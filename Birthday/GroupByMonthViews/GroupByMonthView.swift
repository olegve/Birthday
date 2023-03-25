import SwiftUI
import Contacts


struct GroupByMonthView: View {
    let contacts: [CNContact]
    let thisMonth: Month
    let thisDay: Int
    
    var body: some View {
        let expectedThisMonthBirthdays = contacts.birthdaysThis(month: thisMonth).filter{ $0.birthday!.day! >= thisDay }
        
        return Group{
            // Раздел показывает дни рождения,которые будут в текущем месяце
            if !expectedThisMonthBirthdays.isEmpty {
                SectionView(sectionHeader: LocalizedStringKey("В этом месяце").stringValue(), contacts: expectedThisMonthBirthdays)
            }
            
            // Раздел показывает дни рождения далее (начиная с месяца, следующего за текущим) за 12 месяцев
            ForEach(MonthsSequence[thisMonth.nextMonth]){ month in
                let thisMonthBirthdays = contacts.birthdaysThis(month: month)
                let contacts = month != thisMonth ? thisMonthBirthdays : thisMonthBirthdays.filter{ $0.birthday!.day! < thisDay }
                if !contacts.isEmpty {
                    SectionView(sectionHeader: month.description, contacts: contacts)
                }
            }  //ForEach
        }
    }
}


struct ListByMonthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            List{
                GroupByMonthView(
                    contacts: ContactsModel.shared.contacts.birthdaysThis(month: ContactsModel.shared.now.Month),
                    thisMonth: ContactsModel.shared.now.Month,
                    thisDay:   ContactsModel.shared.now.day
                )
            }
        }
        .environmentObject(ContactsModel.shared)
        .environment(\.locale, .init(identifier: "ru"))
        .environment(\.colorScheme, .dark)
    }
}
