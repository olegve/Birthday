import WidgetKit
import SwiftUI
import Contacts

typealias WidgetDataEntry = ContactsEntry

fileprivate var timelineCounter = 1

struct Provider: TimelineProvider {
    private let shared = ContactsModel.shared
    
    func placeholder(in context: Context) -> WidgetDataEntry {
        WidgetDataEntry(date: Date(), contacts: dataSet1, nextDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetDataEntry) -> ()) {
        let entry = WidgetDataEntry(date: Date(), contacts: dataSet1, nextDate: Date())
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
        let entry = WidgetDataEntry(date: currentDate, contacts: contacts, nextDate: entryDate)
        
        //  ----------------------------------------------------
        let timeline = Timeline(entries: [entry], policy: .after(entryDate))
        completion(timeline)
    }
    
    func getTailSize(depending on:  WidgetFamily, with count: Int) -> Int {
        let minMediumSize = 5
        let minLargeSize = 13
        guard (count > minLargeSize) || (on == .systemMedium && count > minMediumSize) else { return 0 }
        return count - (on == .systemMedium ? minMediumSize : minLargeSize)
    }
}


struct ContactsEntry: TimelineEntry {
    var date: Date
    let contacts: [CNContact]
    let nextDate: Date
}


struct HeaderView: View {
    let nextUpdateDate: Date
    @Environment(\.widgetFamily) var family
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    
    var body: some View {
        Text("Обновление \(nextUpdateDate, formatter: Self.dateFormatter)")
            .bold()
            .foregroundColor(.accentColor)
            .padding(.bottom, family == .systemMedium ? 0 : 0.5)
    }
}


struct ContactView: View {
    let contact: CNContact
    let date: Date
    var days: Int { date.days(until: contact.birthday!.date!) }
    var body: some View {
        HStack{
            Text("\(contact.familyName) \(contact.givenName) \(contact.middleName)")
                .font(.callout)
                .lineLimit(1)
            Spacer()
            Text("\(days)")
                .bold()
        }
        .foregroundColor(days == 0 ? .red : .primary)
        
    }
}



struct BirthdayWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            HeaderView(nextUpdateDate: entry.nextDate)
            ForEach(entry.contacts){ ContactView(contact: $0, date: entry.date) }
            Spacer()
        }
        .fontDesign(.rounded)
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
                date: currentDate,
                contacts: dataSet1
                    .sorted{ currentDate.days(until: $0.birthday!.date!) < currentDate.days(until: $1.birthday!.date!) },
                nextDate: currentDate
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemLarge))
        
        
        BirthdayWidgetEntryView(
            entry: WidgetDataEntry(
                date: currentDate,
                contacts: dataSet1
                    .sorted{ currentDate.days(until: $0.birthday!.date!) < currentDate.days(until: $1.birthday!.date!) },
                nextDate: currentDate
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))

        
        
    }
}

