//
//  EmojiProvider.swift
//  EmojiWidget
//
//  Created by Anastasia Sokolan on 25.11.2020.
//

public struct EmojiProvider {
    /// - Note: Emoji  описания были взяты из[Empojipedia](https://emojipedia.org/).
    static let emojiList: [EmojiDetails] = [
        EmojiDetails(
            emoji: "🎨",
            name: "Artist Palette",
            description: "A palette used by an artist when painting, to store and mix paint colors."),
        EmojiDetails(
            emoji: "😀",
            name: "Grinning Face",
            description: "A yellow face with simple, open eyes and a broad, open smile, showing upper "
            + "teeth and tongue on some platforms."),
        EmojiDetails(
            emoji: "🚀",
            name: "Rocket",
            description: "A rocket being propelled into space."),
        EmojiDetails(
            emoji: "🥰",
            name: "Smiling Face with Hearts",
            description: "A yellow face with smiling eyes, a closed smile, rosy cheeks, and several "
            + "hearts floating around its head."),
        EmojiDetails(
            emoji: "😈",
            name: "Smiling Face with Horns",
            description: "A face, usually purple, with devil horns, a wide grin, and eyes and eyebrows "
            + "scrunched downward on most platforms."),
        EmojiDetails(
            emoji: "🤩",
            name: "Star-Struck",
            description: "A yellow face with a broad, open smile, showing upper teeth on most "
            + "platforms, with stars for eyes, as if seeing a beloved celebrity."),
        EmojiDetails(
            emoji: "🧸",
            name: "Teddy Bear",
            description: "A classic teddy bear, as snuggled by a child when going to sleep."),
        EmojiDetails(
            emoji: "🎾",
            name: "Tennis",
            description: "A tennis racket (racquet) with a tennis ball. Only a ball is shown on Apple, "
            + "LG, Twitter, Facebook, and Mozilla platforms."),
        EmojiDetails(
            emoji: "🦄",
            name: "Unicorn",
            description: "The face of a unicorn, a mythical creature in the form of a white horse with "
            + "a single, long horn on its forehead."),
        EmojiDetails(
            emoji: "🍉",
            name: "Watermelon",
            description: "A slice of watermelon, showing its rich pink flesh, black seeds, and green "
            + "rind.")
    ]
    
    static func random() -> EmojiDetails {
        let randomIndex = Int.random(in: 0..<emojiList.count)
        return emojiList[randomIndex]
    }
}

// kjnkjnkjnk
public struct EmojiDetails: Codable, CustomStringConvertible {
    let emoji: String
    let name: String
    public let description: String
}

extension EmojiDetails: Identifiable {
    public var  id: String { self.emoji }
}
