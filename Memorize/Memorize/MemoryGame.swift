//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Qiru on 2024-07-04.
//

// Model
// 管理数据和业务逻辑。MemoryGame是核心数据模型，处理卡片状态和匹配逻辑。

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }
    
    // 用于跟踪唯一面朝上的index，这是个var
    // 用optional是因为可能没有，可能为nil
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        // 计算并返回当前唯一faceup上的卡片的索引，
        // 如果有多于一个面朝上的卡片或没有面朝上的卡片，则返回 nil。
        // only是对array的自定义extension
        get{ cards.indices.filter{ index in cards[index].isFaceUp }.only}
        
        // 将所有卡片的 isFaceUp 属性设置为 false，（和newValue不match）
        // 只有和newValue match的卡片的FaceUp。
        set{ cards.indices.forEach{ cards[$0].isFaceUp = ($0==newValue)} }
    }
    
    // 处理卡片选择逻辑，匹配和翻转卡片。
    // mutating才能允许修改
    mutating func choose(_ card: Card){
        print(cards)
        // 寻找所选卡片在 cards 数组中的索引，if用于安全地解optional
        
        // 使用 firstIndex(where:) 方法查找所选卡片在 cards 数组中的索引。
        // where 子句用于检查每张卡片的 id 是否与所选卡片的 id 相同。
        // 如果找到了相应的索引，则将其赋值给 chosenIndex。
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}){
            // 确认所选卡片当前没有faceup且没有match
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                // 检查当前是否有且仅有一张faceup的card
                // 如果indexOfTheOneAndOnlyFaceUpCard是nil，则跳过if语句块内的代码。
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                    // 检查两张faceup的卡是否match
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                        // 如果match，将两张cards标记为matched
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    }else{
                        // 如果不match，有扣分机制
                        if cards[chosenIndex].isSeen{ score -= 1 }
                        if cards[potentialMatchIndex].isSeen{ score -= 1 }
                        // 如果不match，前面翻出来的那张会被盖回去，要码住这是看过的牌
                        // 现在翻出来的这张暂时不会被盖回去，等到下次盖回去再标注已看过
                        cards[potentialMatchIndex].isSeen = true
                        cards[chosenIndex].isSeen = true
                    }
                }else{
                    // 如果没有faceup的卡片，将所选card的index设为唯一faceup的index
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                // 翻转当前card
                cards[chosenIndex].isFaceUp = true

            }
        }
        print(cards)
    }
    
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    
    mutating func newGame(){
        
    }
    
    // 遵循 Equatable 协议意味着可以直接比较两个 Card 实例是否相等
    // Identifiable 协议要求类型具有一个 id 属性，用于唯一标识实例
    // CustomDebugStringConvertible 协议要求类型实现一个 debugDescription 计算属性，用于提供自定义的调试描述信息。可以通过打印或调试工具查看卡片的详细状态。
    // Card是MemoryGame的组成部分，因此将其嵌套在MemoryGame中有助于封装和组织代码。
    // Card与MemoryGame之间存在强依赖关系，Card不太可能在MemoryGame之外单独使用。
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        let content: CardContent
        
        var id: String
        var debugDescription: String{
            "\(id): \(content) \(isSeen ? "seen" : "new") \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }
    }
    
}

// Theme代表的是游戏的不同主题，这些主题应该可以在整个应用程序中独立于MemoryGame使用和管理。
// Theme与MemoryGame之间的关系不是紧密耦合的，而是配置和管理的关系。
struct Theme<CardContent>{
    let name: String
    let content: [CardContent]
    let color: Color
    let numberOfPairsOfCards: Int
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
