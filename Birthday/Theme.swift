import UIKit
import SwiftUI

let theme1 = "Theme3B8686"
let themeName = theme1

// Цвета заголовка
let titleBackground = Color("\(themeName)/titleBackground")
let titleForeground = Color("\(themeName)/titleForeground")
let TitleTint = Color("\(themeName)/titleTint")

// Цвета основного контента
let contentBackground = Color("\(themeName)/contentBackground")
let contentForeground = Color("\(themeName)/contentForeground")
let contentTint = Color("\(themeName)/contentTint")
let contentSeparator = Color("\(themeName)/separator")

let sectionForeground = Color("\(themeName)/sectionForeground")
let sectionBackground = Color("\(themeName)/sectionBackground")



// Темы оформления заголовка виджета
func color(hex: Int) -> Double { Double(hex) / Double(0xFF) }

struct DarkTheme {
    static let background = Color(red: color(hex: 0x3B), green: color(hex: 0x86), blue: color(hex: 0x86))
    static let foreground = Color(red: color(hex: 0xE6), green: color(hex: 0xFE), blue: color(hex: 0xF0))
}


struct LightTheme {
    static let background = Color(red: color(hex: 0x54), green: color(hex: 0xA4), blue: color(hex: 0xA4))
    static let foreground = Color(red: color(hex: 0x24), green: color(hex: 0x4B), blue: color(hex: 0x4B))
}


extension Color {
    func uiColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let scanner = Scanner(string: description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000FF) / 255
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


class Theme {
    static func navigationBarColors(background : UIColor?, titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        let navigationAppearance = UINavigationBarAppearance()
        
        /// this overrides everything you have set up earlier.
        navigationAppearance.configureWithTransparentBackground()
//        navigationAppearance.configureWithOpaqueBackground()
//        navigationAppearance.backgroundColor = background ?? .clear
//        navigationAppearance.backButtonAppearance =
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
        
     
        /// Этот раздел работает с поисковой строкой
//        UISearchBar.appearance().backgroundColor = background ?? .clear
        UISearchBar.appearance().tintColor = tintColor ?? titleColor ?? .white
//        UISearchBar.appearance().barTintColor = UIColor.white
        
        /// Этот раздел также работает с поисковой строкой
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .systemBackground//.white
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = titleColor ?? .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = tintColor ?? titleColor ?? .black
    
    }
    
    static func navigationBarColors(background : Color?, titleColor : Color? = nil, tintColor : Color? = nil ){
        navigationBarColors(background: background?.uiColor(), titleColor: titleColor?.uiColor(), tintColor: tintColor?.uiColor())
    }
    
    static func foregroundColor(scheme: ColorScheme) -> Color {
        scheme == .light ? LightTheme.foreground : DarkTheme.foreground
    }
    
    static func backgroundColor(scheme: ColorScheme) -> Color {
        scheme == .light ? LightTheme.background : DarkTheme.background
    }
}
