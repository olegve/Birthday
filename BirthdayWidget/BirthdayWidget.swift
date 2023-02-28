import WidgetKit
import SwiftUI
import Contacts

typealias WidgetDataEntry = ContactsEntry

fileprivate var timelineCounter = 1

struct Provider: TimelineProvider {
    private let shared = ContactsModel.shared
    
    func placeholder(in context: Context) -> WidgetDataEntry {
        WidgetDataEntry(date: Date(), contacts: dataSet1)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetDataEntry) -> ()) {
        let entry = WidgetDataEntry(date: Date(), contacts: dataSet1)
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [WidgetDataEntry] = []

        // Generate a timeline
        let currentDate = Date()
        shared.updateContacts()
        var contacts = shared.contacts
            .sorted{ currentDate.days(until: $0.birthday!.date!) < currentDate.days(until: $1.birthday!.date!) }
        contacts.removeLast( getTailSize(depending: context.family, with: shared.contacts.count) )
        
        let nextDay   = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        let entryDate = Calendar.current.startOfDay(for: nextDay)
        let entry = WidgetDataEntry(date: currentDate, contacts: contacts)
        
        //  ----------------------------------------------------
        let timeline = Timeline(entries: [entry], policy: .after(entryDate))
        completion(timeline)
    }
    
    func getTailSize(depending on:  WidgetFamily, with count: Int) -> Int {
        let minMediumSize = 5
        let minLargeSize = 10
        guard (count > minLargeSize) || (on == .systemMedium && count > minMediumSize) else { return 0 }
        return count - (on == .systemMedium ? minMediumSize : minLargeSize)
    }
}


struct ContactsEntry: TimelineEntry {
    var date: Date
    let contacts: [CNContact]
}



struct BirthdayWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading){
            Text("Ближайшие дни рождения \(entry.contacts.count)")
                .bold()
                .foregroundColor(.accentColor)
                .padding(.bottom, 1.0)
            ForEach(entry.contacts){ contact in
                HStack(){
                    Text("\(contact.familyName) \(contact.givenName) \(contact.middleName)")
                        .font(.callout)
                    Spacer()
                    Text("\(entry.date.days(until: contact.birthday!.date!))")
                        .bold()
                }
            }
            Spacer()
        }
        .padding(.all)
    }
}


struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Birthday Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}


struct BirthdayWidget_Previews: PreviewProvider {
    static let currentDate = Date()
    
    static var previews: some View {
        BirthdayWidgetEntryView(
            entry: WidgetDataEntry(
                date: Date(),
                contacts: dataSet1
                    .sorted{ currentDate.days(until: $0.birthday!.date!) < currentDate.days(until: $1.birthday!.date!) }
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
