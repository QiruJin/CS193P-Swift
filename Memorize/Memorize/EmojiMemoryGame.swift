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
    // inside global variable, will be initialize first

    private static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        
        let shuffledEmojis = theme.content.shuffled()
        // MemoryGame的参数：
        // numberOfPairsOfCards: Int,
        // cardContentFactory: (Int) -> CardContent 注意(Int)是输入值，
        // 也就是这里定义的cardContentFactory是返回emojis中index的值
        let numberOfPairsOfCards = theme.numberOfPairsOfCards
        let randomNumberOfPairs = Int.random(in: numberOfPairsOfCards/2 ... numberOfPairsOfCards)
        return MemoryGame(numberOfPairsOfCards: randomNumberOfPairs) { pairIndex in
            // (Int) -> cardContent
            if shuffledEmojis.indices.contains(pairIndex){
                return shuffledEmojis[pairIndex] // $0 is placeholder of first variable
            }else{
                return "⁉️"
            }
        }
    }
    
    private static let themes: [Theme<String>] = [
        Theme(name: "Halloween", content: ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺"], color: Color.orange, numberOfPairsOfCards: 8),
        Theme(name: "People", content: ["👶🏻", "👧🏻", "💂🏻‍♀️", "👮🏻‍♀️", "👩🏻‍⚕️", "👩🏻‍🌾", "👩🏻‍💻", "👩🏻‍🎓"], color: Color.black, numberOfPairsOfCards: 8),
        Theme(name: "Food", content: ["🥐", "🥯", "🥨", "🌯", "🥟", "🍨", "🍫", "🍲"], color: Color.yellow, numberOfPairsOfCards: 8),
        Theme(name: "Animal", content: ["🐶", "🦁", "🐷", "🦊", "🐰", "🐼", "🐵", "🐸"], color: Color.green, numberOfPairsOfCards: 8),
        Theme(name: "Flags", content: ["🇺🇸", "🇨🇦", "🇲🇽", "🇯🇵"], color: Color.red, numberOfPairsOfCards: 4),
        Theme(name: "Sports", content: ["⚽️", "🏀", "🏈", "⚾️"], color: Color.blue, numberOfPairsOfCards: 4)
        
    ]
    
    // @Published属性包装器，表示当model发生变化时，会自动通知观察者。
    // 后面是包装了model也就是createMemoryGame也就是MemoryGame的函数
    // private var：属性既不能被外部读取也不能被外部修改。
    // private(set) var：属性可以被外部读取，但不能被外部修改。
    @Published private var model: MemoryGame<String>
    @Published private(set) var theme: Theme<String>
    
    // 实例的属性尚未完全初始化，而静态变量EmojiMemoryGame.themes已经存在并且是可用的。
    // 因此，我们需要使用完整的类名来访问静态变量。
    // 这样可以确保在实例完全构造之前访问和使用静态变量，而不会产生未定义行为或崩溃。
    init() {
        let initialTheme = EmojiMemoryGame.themes.randomElement()!
        theme = initialTheme
        model = EmojiMemoryGame.createMemoryGame(theme: initialTheme)
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var score: Int {
        return model.score
    }
    
    var isGameOver: Bool {
        return model.isGameOver
    }
    
    var themeColor: Color{
        return theme.color
    }
    
    // MARK: - Intents

    func newGame(){
        let initialTheme = EmojiMemoryGame.themes.randomElement()!
        theme = initialTheme
        model = EmojiMemoryGame.createMemoryGame(theme: initialTheme)
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
}
