import Foundation


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    /// - Returns: Возвращает месяц в виде строки в текущей локали.
    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = .autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
    
    /// - Returns: Возвращает месяц в формате Month (Month.jan, Month.feb, Month.mar, ...).
    var Month: Month { MonthsSequence.start(from: .jan)[month - 1] }
    
    /// - Returns: Возвращает день.
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    /// - Returns: Возвращает месяц.
    var month: Int {
        Calendar.current.component(.month, from: self) 
    }
    
    /// - Returns: Возвращает год.
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    /// Возвращает дату.
    /// - Parameters:
    ///   - day: день
    ///   - month: месяц
    ///   - year: год
    /// - Returns: Дата с необходимым днём, месяцем и годом по григорианскому календарю.
    static func makeDate(day: Int, month: Int, year: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: DateComponents(year: year, month: month, day: day))
    }
    
    /// Функция вычисляет количество дней до даты.
    /// - Parameter date: Дата, до которой вычисляется количество дней
    /// - Returns: Количество дней до даты
    func days(until date: Date) -> Int {
        if self.day == date.day && self.month == date.month { return 0 }
        let cal = Calendar.current
        let fromDate  = cal.startOfDay(for: self)
        let untilDate = cal.startOfDay(for: date)
        let components = cal.dateComponents([.day, .month], from: untilDate)
        let nextDate  = cal.nextDate(after: fromDate, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        return cal.dateComponents([.day], from: fromDate, to: nextDate ?? fromDate).day ?? 0
    }
}


