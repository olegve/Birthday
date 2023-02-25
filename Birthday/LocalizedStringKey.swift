import SwiftUI
import os


extension LocalizedStringKey {
    private static let logger = Logger(
           subsystem: Bundle.main.bundleIdentifier!,
           category: String(describing: LocalizedStringKey.self)
       )
    
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
    
    func stringValue(locale: Locale = .current) -> String {
        if let stringKey = self.stringKey {
           return .localizedString(for: stringKey, locale: locale)
        } else {
            Self.logger.trace("В текущей локали не возможно подобрать нужное значение")
            return "Error Localize"
        }
    }
}


extension String {
    static func localizedString(for key: String, locale: Locale = .current) -> String {
        let language = locale.language.languageCode!.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

