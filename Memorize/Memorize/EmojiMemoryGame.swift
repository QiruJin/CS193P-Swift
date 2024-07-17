//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Qiru on 2024-07-04.
//

// ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // inside global variable, will be initialize first
    private static let emojis = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺", "🦇", "🧟‍♀️"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 12) { pairIndex in
            // (Int) -> cardContent
            if emojis.indices.contains(pairIndex){
                return emojis[pairIndex] // $0 is placeholder of first variable
            }else{
                return "⁉️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle(){
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
}
