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
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2  , numberOfPairsOfCards) {
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
                        // 除了基础得分还有bonus得分（来自两张卡）
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    }
                    else{
                        if cards[chosenIndex].hasBeenSeen{
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen{
                            score -= 1
                        }
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
        var isFaceUp: Bool = false{
            // 当 isFaceUp 的值发生改变时，didSet 观察器会被触发。
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                } else{
                    stopUsingBonusTime()
                }
                // 如果卡片之前是正面朝上 (oldValue 是 true)，而现在翻到背面 (isFaceUp 是 false)，则满足条件。
                if oldValue && !isFaceUp{
                    hasBeenSeen = true
                }
            }
        }
        var hasBeenSeen: Bool = false
        var isMatched: Bool = false {
            // 当 isMatched 的值发生改变时，didSet 观察器会被触发。
            didSet {
                // 如果match就不会facedown了，所以记得停止计算bonus
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        
        var id: String
        var debugDescription: String{
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }
        
        // MARK: - Bonus Time
        
        // 只有在这个时间内才能得到bonus
        var bonusTimeLimit: TimeInterval = 6
        
        // 最近一次card face up的时候
        var lastFaceUpDate: Date?
        
        // 这张牌过去face up的总时间
        var pastFaceUpTime: TimeInterval = 0
        
        // 计算这张牌总共face up的时间
        // 即过去face up的时间和现在face up的时间
        var faceUpTime: TimeInterval{
            // 如果当前卡牌朝上，这个值不会是nil，那么需要计算之前+当下的时间
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // 还剩下的bonus百分比
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // 目前为止得到的附加分
        // 看牌时间越长，bonus越少
        var bonus: Int{
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // 当这张牌从down到up，开始这张牌的bonus计算时间
        private mutating func startUsingBonusTime(){
            // 计算有意义的前提是这张牌刚被faceUp（faceUp & lastFaceUpdate == nil表示刚翻过来，防止重复计算）
            // 还有它还没被match，剩余的奖励时间不为空
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // 当这张牌从up到down，结束这张牌此次的bonus计算时间
        private mutating func stopUsingBonusTime(){
            // 记录这张牌目前为止的faceUp时间
            pastFaceUpTime = faceUpTime
            // 重置
            lastFaceUpDate = nil
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
