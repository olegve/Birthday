//
//  ContentView.swift
//  EmojiWidget
//
//  Created by Anastasia Sokolan on 25.11.2020.
//

import SwiftUI
import WidgetKit

struct ExampleContentView: View {
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.stinco.Birhday"))
    var emojiData = Data()
    
    var body: some View {
        Button(action: {
            let emoji = EmojiProvider.random()
            print("Action.  New emoji is \(emoji.emoji)")
            save(emoji)
            WidgetCenter.shared.reloadTimelines(ofKind: "MyEmojiWidget")
        }, label: {
            Text("Tap me!")
        })
    }
    
    private func save(_ emoji: EmojiDetails) {
        guard let data = try? JSONEncoder().encode(emoji) else {
            return
        }
        emojiData = data
    }
}

struct ExampleContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleContentView()
    }
}
