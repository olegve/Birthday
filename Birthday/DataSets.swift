import Contacts


var dataSet1: [CNContact] {
    var contacts = [CNContact]()
    
    // Specify date components
    var dateComponents = DateComponents()
    dateComponents.year = 2001
    dateComponents.month = 9
    dateComponents.day = 2
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact = CNMutableContact()
    contact.contactType = .person
    contact.familyName = "Ефремов"
    contact.givenName = "Данила"
    contact.middleName = "Олегович"
    contact.birthday = dateComponents
    contact.birthday!.calendar =  Calendar(identifier: .gregorian)
    
    contacts.append(contact as CNContact)
    
    // Specify date components
    dateComponents.year = 1966
    dateComponents.month = 4
    dateComponents.day = 30
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact2 = CNMutableContact()
    contact2.contactType = .person
    contact2.familyName = "Ефремов"
    contact2.givenName = "Олег"
    contact2.middleName = "Владимирович"
    contact2.birthday = dateComponents
    contact2.birthday!.calendar =  Calendar(identifier: .gregorian)
    
    contacts.append(contact2 as CNContact)
    
    // Specify date components
    dateComponents.year = 1966
    dateComponents.month = 4
    dateComponents.day = 22
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact3 = CNMutableContact()
    contact3.contactType = .person
    contact3.familyName = "Егоров"
    contact3.givenName = "Александр"
    contact3.middleName = "Евсеевич"
    contact3.birthday = dateComponents
    contact3.birthday!.calendar =  Calendar(identifier: .gregorian)
    
    contacts.append(contact3 as CNContact)

    // Specify date components
    dateComponents.year = 1966
    dateComponents.month = 2
    dateComponents.day = 22
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact4 = CNMutableContact()
    contact4.contactType = .person
    contact4.familyName = "Ершов"
    contact4.givenName = "Аркадий"
    contact4.middleName = "Семёнович"
    contact4.birthday = dateComponents
    contact4.birthday!.calendar =  Calendar(identifier: .gregorian)
    
    contacts.append(contact4 as CNContact)
    
    // Specify date components
    dateComponents.year = 1966
    dateComponents.month = 2
    dateComponents.day = 2
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact5 = CNMutableContact()
    contact5.contactType = .person
    contact5.familyName = "Егоров"
    contact5.givenName = "Николай"
    contact5.middleName = "Николаевич"
    contact5.birthday = dateComponents
    contact5.birthday!.calendar =  Calendar(identifier: .gregorian)
    
    contacts.append(contact5 as CNContact)
    
    return contacts
}


var dataSet2: [CNContact] {
    var contacts = [CNContact]()
    var dateComponents = DateComponents()

    // Specify date components
    dateComponents.year = 2001
    dateComponents.month = 3
    dateComponents.day = 6
    dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
    dateComponents.hour = 18
    dateComponents.minute = 34
    
    let contact = CNMutableContact()
    contact.contactType = .person
    contact.familyName = "Семёнов"
    contact.givenName = "Семён"
    contact.middleName = "Эрастович"
    contact.birthday = dateComponents
    contact.birthday!.calendar =  Calendar(identifier: .gregorian)

    contacts.append(contact as CNContact)
        
    return contacts
}


let dataSet3: [CNContact] = []

