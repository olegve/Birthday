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
        let contactFormatter: CNContactFormatter = {
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            return formatter
        }()

//        var entries: [WidgetDataEntry] = []

        // Generate a timeline
        let currentDate = Date()
        shared.updateContacts()
        var contacts = shared.contacts
            .sorted{ lhs, rhs in
                let lhsDay = currentDate.days(until: lhs.birthday!.date!)
                let rhsDay = currentDate.days(until: rhs.birthday!.date!)
                guard lhsDay == rhsDay else { return lhsDay < rhsDay }
                return contactFormatter.string(from: lhs)! < contactFormatter.string(from: rhs)!
            }
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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("Ближайшие дни рождения")
            .lineLimit(1)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(Theme.foregroundColor(scheme: colorScheme))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Theme.backgroundColor(scheme: colorScheme).gradient)
    }
}


struct ContactView: View {
    let contact: CNContact
    let date: Date
    var days: Int { date.days(until: contact.birthday!.date!) }
    
    var body: some View {
        HStack{
            ContactNameView(contact: contact)
                .lineLimit(1)
            Spacer()
            Text("\(days)")
                .fontWeight(.bold)
        }
        .foregroundColor(days == 0 ? .red : .primary)
    }
}


struct BirthdayWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            // Code to construct the view for the rectangular Lock Screen widget or watch complication.
            ZStack{
//                AccessoryWidgetBackground()
//                    .cornerRadius(8)
                VStack{
                    ForEach(0...2, id: \.self){ ContactView(contact: entry.contacts[$0], date: entry.date) }
                }
                .padding(.horizontal, 5)
            }
        case .systemLarge:
            // Code to construct the view for the large widget.
            VStack(alignment: .leading){
                HeaderView()
                VStack{
                    ForEach(0..<(entry.contacts.count > 8 ? 8 : entry.contacts.count), id: \.self){ index in
                        Link(destination: URL(string: "widget-deeplink-contact://\(entry.contacts[index].identifier)")!){
                            ContactView(contact: entry.contacts[index], date: entry.date)
                                .frame(height: 19)
                                .padding(.horizontal, 4)
                            Divider()
                        }
                    }
                }
                .padding([.leading, .bottom, .trailing], 10)
                Spacer()
            }
            .font(.callout)
            .fontDesign(.rounded)
            //.padding(.all)
        case .systemMedium:
            // Code to construct the view for the medium widget.
            VStack(alignment: .leading){
                HeaderView()
                VStack{
                    ForEach(0..<(entry.contacts.count > 3 ? 3 : entry.contacts.count), id: \.self){ index in
                        Link(destination: URL(string: "widget-deeplink-contact://\(entry.contacts[index].identifier)")!) {
                            ContactView(contact: entry.contacts[index], date: entry.date)
                                .frame(height: 19)
                                .padding(.horizontal, 4)
                            Divider()
                        }
                    }
                }
                .padding([.leading, .bottom, .trailing], 10)
                Spacer()
            }
            .font(.callout)
            .fontDesign(.rounded)
        default:
            // Code to construct the view for other widgets; for example, the system medium or large widgets.
            Text("Unused Widget")
        }
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
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryRectangular])
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

        
        BirthdayWidgetEntryView(
            entry: WidgetDataEntry(
                date: currentDate,
                contacts: dataSet1
                    .sorted{ currentDate.days(until: $0.birthday!.date!) < currentDate.days(until: $1.birthday!.date!) },
                nextDate: currentDate
            )
        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

    }
}

