//
//  SetGame.swift
//  SetGame
//
//  Created by Qiru on 2024-08-15.
//

// Model
// 管理数据和业务逻辑。SetGame是核心数据模型，处理卡片状态和匹配逻辑。

import Foundation

// ObservableObject protocol可以和SwiftUI 绑定，数据变化时自动更新View
struct SetGame{
    
    private(set) var deck: [Card]
    private(set) var cardsInPlay: [Card]
    private(set) var selectedCards: [Card] = []
    private(set) var matchedCards: [Card] = []
    
    init(){
        deck = Card.generateDeck()
        cardsInPlay = []
        // 初始发牌12张
        dealCards(count: 12)
    }
    
    // 从牌堆中发牌
    // parameter: count 发牌数量
    // mutating才能允许修改
    mutating func dealCards(count : Int){
        for _ in 0..<count{
            // 先判断deck里面是否还有牌
            if let card = deck.popLast(){
                cardsInPlay.append(card)
            }
        }
    }
    
    // 发三张牌
    mutating func dealThreeCards(){
        // 防止要发的牌过多
        let count = min(deck.count, 3)
        dealCards(count: count)
    }
    
    // 处理被选择的卡片，将其添加进合适的列表，并更改它的信息
    // 如果点击的已选择卡片则取消选择, 未选择卡片则添加入已选择卡片
    // 选了3张卡即开始判断并处理牌堆
    // parameter: card 被选择的卡片
    mutating func chooseCard(card : Card){
        // 寻找所选卡片在 cards 数组中的索引，if用于安全地解optional
        // 使用 firstIndex(where:) 方法查找所选卡片在 cardsInPlay 数组中的索引。
        // where 子句用于检查每张卡片的 id 是否与所选卡片的 id 相同。
        // 如果找到了相应的索引，则将其赋值给 chosenIndex
        if let choosenIndex = cardsInPlay.firstIndex(where: {$0.id == card.id}){
            // 如果点击的已选择卡片则取消选择, 未选择卡片则添加入已选择卡片
            //----------//
            print(card.debugDescription)
            //----------//
            if selectedCards.contains(cardsInPlay[choosenIndex]){
                cardsInPlay[choosenIndex].isSeleted = false
                selectedCards.removeAll(where: {$0.id==card.id})
                //----------//
                print("already in:", card.debugDescription)
                printSelect()
                //----------//
            }else{
                selectedCards.append(cardsInPlay[choosenIndex])
                cardsInPlay[choosenIndex].isSeleted = true
                // 选了3张卡即开始判断并处理牌堆
                //----------//
                print("new: ", card.debugDescription)

                printSelect()
                //----------//
                if selectedCards.count == 3{
                    // match or not
                    print("is 3 now")
                    printSelect()
                    if isSet(selectedCards){
                        // 如果符合set，添加进符合要求的牌堆
                        matchedCards.append(contentsOf: selectedCards)
                        // 并且移除这三张卡并替换成新的（如果牌堆里还有的话）
                        replaceAndRemoveMatchedCards()
                    }
                    // no matter matched or not, 这个set选择过程结束，换新的牌
                    selectedCards.removeAll()
                }
            }
        }
    }
    func printSelect(){
        print(selectedCards.count)
        for card in selectedCards{
            print(card.debugDescription)
        }
    }
    // 开始新游戏，重新初始化卡片状态
    mutating func startNewGame(){
        // 初始化牌堆和牌桌
        deck = Card.generateDeck()
        cardsInPlay.removeAll()
        selectedCards.removeAll()
        matchedCards.removeAll()
        dealCards(count: 12)
    }
    
    // 判断选中的三张卡片是否构成Set的方法
    mutating func isSet(_ cards : [Card]) -> Bool{
        if cards.count != 3 {return false}
        
        // Set 是一种集合类型，它用于存储唯一的值，用来去重
        // map用来对cards中的每一个元素进行同样的操作
        let symbolSet = Set(cards.map{$0.symbol})
        let colorSet = Set(cards.map{$0.color})
        let numberSet = Set(cards.map{$0.number})
        let shadingSet = Set(cards.map{$0.shading})
        
        // 如果3张牌完全不同，或者3张牌在某一个/一些属性上有相同的即为set
        // 不能出现只有2张牌在一个/一些属性上有相同的存在
        // 也就是说上面的set应该都是1(3张在这个属性上完全相同)或者3(3张完全不同)
        let isSet = (symbolSet.count == 1 || symbolSet.count == 3) &&
                    (colorSet.count == 1 || colorSet.count == 3) &&
                    (numberSet.count == 1 || numberSet.count == 3) &&
                    (shadingSet.count == 1 || shadingSet.count == 3)

        return isSet
    }
    
    // replace matched card in cardInPlay
    mutating func replaceAndRemoveMatchedCards(){
        for card in selectedCards{
            if let index = cardsInPlay.firstIndex(where: {$0.id == card.id}){
                cardsInPlay[index].isSeleted = false
            }
            selectedCards.removeAll()
        }
    }
    
    // replace matched card in cardInPlay
    mutating func removeSelectedCards(){
        for card in selectedCards{
            // 如果在牌桌上能找到这张牌，移除它，并且补充它
            if let index = cardsInPlay.firstIndex(where: {$0.id == card.id}){
                cardsInPlay[index].isSeleted = false
                cardsInPlay[index].isMatched = true
                // 如果牌堆没空，补充牌
                if !deck.isEmpty{
                    cardsInPlay[index] = deck.popLast()!
                }else{
                    cardsInPlay.remove(at: index)
                }
            }
        }
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible{
        
        let id: UUID
        let symbol: Symbol
        let color: Color
        let number: Number
        let shading: Shading
        var isSeleted: Bool = false
        var isMatched: Bool = false
        
        // 枚举类型定义卡片的属性
        // CaseIterable 是一个协议，
        // 用于让枚举类型自动生成一个包含所有枚举情况的集合。
        // 这在需要遍历所有枚举情况或统计枚举情况数量时非常有用。
        // 比如我们在后面要用allCase遍历
        enum Symbol: CaseIterable{
            case diamond
            case rectangle
            case oval
        }
        
        enum Color: CaseIterable{
            case red
            case green
            case purple
        }
        
        // 如果不显式指定 case one = 1，
        // 编译器会自动从 0 开始为枚举成员分配整数原始值。
        enum Number: Int, CaseIterable{
            case one = 1
            case two
            case three
        }
        
        enum Shading: CaseIterable{
            case solid
            case striped
            case open
        }
        
        var debugDescription: String{
            "\(id): \(symbol) \(number) \(shading) \(isSeleted ? "selected" : "noselect") \(isMatched ? "matched" : "noMatch") "
        }
        
        // 生成所有可能的卡片组合
        // 放在结构体内部能够简化访问，并且让代码更具可读性和组织性。
        // generateDeck 方法被明确地与 Card 类型绑定在一起，
        // 表明它是 Card 类型的一个附属功能，而不是一个通用的外部函数。
        // static静态方法可以直接通过类型调用，否则需实例化类型。
        static func generateDeck() -> [Card]{
            var deck = [Card]()
            for symbol in Symbol.allCases{
                for color in Color.allCases{
                    for number in Number.allCases{
                        for shading in Shading.allCases{
                            deck.append(Card(
                                id: UUID(),
                                symbol: symbol,
                                color: color,
                                number: number,
                                shading: shading))
                        }
                    }
                }
            }
            return deck.shuffled()
        }

    }


}
