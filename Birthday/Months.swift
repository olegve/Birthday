import Foundation

/// Месяцы
enum Month: Int, CaseIterable {
    case jan =  1
    case feb =  2
    case mar =  3
    case apr =  4
    case may =  5
    case jun =  6
    case jul =  7
    case aug =  8
    case sep =  9
    case oct = 10
    case nov = 11
    case dec = 12
}

extension Month {
    var nextMonth: Month {
        switch self {
        case .jan: return .feb
        case .feb: return .mar
        case .mar: return .apr
        case .apr: return .may
        case .may: return .jun
        case .jun: return .jul
        case .jul: return .aug
        case .aug: return .sep
        case .sep: return .oct
        case .oct: return .nov
        case .nov: return .dec
        case .dec: return .jan
        }
    }
}
    
extension Month: CustomStringConvertible {
    /// Название месяца
    var description: String { Date.makeDate(day: 1, month: rawValue, year: 2000)!.monthString }
}

extension Month: Identifiable {
    var id: Int { rawValue }
}

extension Month: Equatable {
    static func ==(lhs: Month, rhs: Month) -> Bool { lhs.rawValue == rhs.rawValue }
}

extension Month: Comparable {
    static func <(lhs: Month, rhs: Month) -> Bool { lhs.rawValue < rhs.rawValue }
}

extension Month: Hashable {}

/// Последовательности месяцев
struct MonthsSequence {
    private static let janSequence: [Month] = [.jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec]
    private static let febSequence: [Month] = [.feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec, .jan]
    private static let marSequence: [Month] = [.mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec, .jan, .feb]
    private static let aprSequence: [Month] = [.apr, .may, .jun, .jul, .aug, .sep, .oct, .nov, .dec, .jan, .feb, .mar]
    private static let maySequence: [Month] = [.may, .jun, .jul, .aug, .sep, .oct, .nov, .dec, .jan, .feb, .mar, .apr]
    private static let junSequence: [Month] = [.jun, .jul, .aug, .sep, .oct, .nov, .dec, .jan, .feb, .mar, .apr, .may]
    private static let julSequence: [Month] = [.jul, .aug, .sep, .oct, .nov, .dec, .jan, .feb, .mar, .apr, .may, .jun]
    private static let augSequence: [Month] = [.aug, .sep, .oct, .nov, .dec, .jan, .feb, .mar, .apr, .may, .jun, .jul]
    private static let sepSequence: [Month] = [.sep, .oct, .nov, .dec, .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug]
    private static let octSequence: [Month] = [.oct, .nov, .dec, .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep]
    private static let novSequence: [Month] = [.nov, .dec, .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct]
    private static let decSequence: [Month] = [.dec, .jan, .feb, .mar, .apr, .may, .jun, .jul, .aug, .sep, .oct, .nov]
    private static let monthsSequence = [janSequence, febSequence, marSequence, aprSequence, maySequence, junSequence, julSequence, augSequence, sepSequence, octSequence, novSequence, decSequence]
    /// Последовательность месяцев, начиная с номера **Index**
    static subscript(index: Int) -> [Month]   { monthsSequence[index] }
    /// Последовательность месяцев, начиная с месяца **month**
    static subscript(month: Month) -> [Month] { monthsSequence[month.rawValue - 1] }
    /// Последовательность месяцев, начиная с месяца **month**
    static func start(from month: Month) -> [Month] { MonthsSequence[month] }
}
