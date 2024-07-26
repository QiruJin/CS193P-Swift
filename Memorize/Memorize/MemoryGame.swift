//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Qiru on 2024-07-04.
//

// Model
// 管理数据和业务逻辑。MemoryGame是核心数据模型，处理卡片状态和匹配逻辑。

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
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
                    }
                }else{
                    // 如果没有faceup的卡片，将所选card的index设为唯一faceup的index
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                // 翻转当前card
                cards[chosenIndex].isFaceUp = true

            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    
    // 遵循 Equatable 协议意味着可以直接比较两个 Card 实例是否相等
    // Identifiable 协议要求类型具有一个 id 属性，用于唯一标识实例
    // CustomDebugStringConvertible 协议要求类型实现一个 debugDescription 计算属性，用于提供自定义的调试描述信息。可以通过打印或调试工具查看卡片的详细状态。
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        
        var id: String
        var debugDescription: String{
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
