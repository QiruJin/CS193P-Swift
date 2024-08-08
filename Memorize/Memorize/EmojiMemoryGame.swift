//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Qiru on 2024-07-04.
//

// ViewModel
// 连接Model和View，提供数据和操作。EmojiMemoryGame负责创建和管理MemoryGame实例，并提供卡片数据给视图。

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // namespace
    typealias Card = MemoryGame<String>.Card
    
    // inside global variable, will be initialize first
    private static let emojis = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺", "🦇", "🧟‍♀️"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        // MemoryGame的参数：
        // numberOfPairsOfCards: Int,
        // cardContentFactory: (Int) -> CardContent 注意(Int)是输入值，
        // 也就是这里定义的cardContentFactory是返回emojis中index的值
        return MemoryGame(numberOfPairsOfCards: 2) { pairIndex in
            // (Int) -> cardContent
            if emojis.indices.contains(pairIndex){
                return emojis[pairIndex] // $0 is placeholder of first variable
            }else{
                return "⁉️"
            }
        }
    }
    
    // @Published属性包装器，表示当model发生变化时，会自动通知观察者。
    // 后面是包装了model也就是createMemoryGame也就是MemoryGame的函数
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle(){
        model.shuffle()
    }
    
    func choose(_ card: Card){
        model.choose(card)
    }
}
