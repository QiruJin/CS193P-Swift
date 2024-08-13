//
//  SetGame.swift
//  Memorize
//
//  Created by Qiru on 2024-08-12.
//

// Model
// 管理数据和业务逻辑。SetGame是核心数据模型，处理卡片状态和匹配逻辑。

import Foundation

// 遵循 ObservableObject 协议，这样可以与 SwiftUI 视图绑定，数据变化时自动更新视图。
class SetGame: ObservableObject {
    // MARK: - Properties

    @Published private(set) var deck: [Card]  // 牌堆
    @Published private(set) var cardsInPlay: [Card]  // 当前在屏幕上的卡片
    @Published private(set) var selectedCards: [Card] = []  // 选中的卡片
    @Published private(set) var matchedCards: [Card] = []  // 已匹配的卡片
    
    // MARK: - Initializer

    init() {
        deck = Card.generateDeck()
        cardsInPlay = []
        dealCards(count: 12)  // 初始发牌12张
    }
    
    // MARK: - Methods

    // 从牌堆中发牌
    func dealCards(count: Int = 3) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                cardsInPlay.append(card)
            }
        }
    }
    
    // 从牌堆中再发三张牌，防止超过deck的可提供范围
    func dealThreeCards(count: Int = 3){
        let count = min(count, deck.count)
        dealCards(count: count)
    }
    
    // 处理用户选择卡片的逻辑
    func chooseCard(_ card: Card){
        // 寻找所选卡片在 cards 数组中的索引，if用于安全地解optional
        // 使用 firstIndex(where:) 方法查找所选卡片在 cardsInPlay 数组中的索引。
        // where 子句用于检查每张卡片的 id 是否与所选卡片的 id 相同。
        // 如果找到了相应的索引，则将其赋值给 chosenIndex
        if let chosenIndex = cardsInPlay.firstIndex(where: {$0.id == card.id}){
            // 如果点击的已选择卡片则取消选择
            // .contains要求集合的元素类型实现了 Equatable 协议，以便能够进行直接比较。
            if selectedCards.contains(card){
                selectedCards.removeAll{$0.id == card.id}
                cardsInPlay[chosenIndex].isSelected = false
            } else{ // 如果选择的未选择卡片则添加入已选择卡片
                selectedCards.append(cardsInPlay[chosenIndex])
                cardsInPlay[chosenIndex].isSelected = true
                // 并且判断是否已经到了该判断是否正确的时候（选择了3张卡）
                if selectedCards.count == 3{
                    // 选了3张卡即开始判断，并且移除所有已选择的卡牌进行新的set选择
                    // 这个set符合要求
                    if isSet(selectedCards){
                        // 如果符合set，添加进符合要求的牌堆
                        matchedCards.append(contentsOf: selectedCards)
                        // 并且移除这三张卡并替换成新的（如果牌堆里还有的话）
                        replaceOrRemoveMatchedCards()
                    }
                    // 这个set选择过程结束，换新的牌
                    selectedCards.removeAll()
                }
            }
        }
    }
    
    // 开始新游戏，重新初始化卡片状态
    func startNewGame() {
        // 初始化牌堆和牌桌
        deck = Card.generateDeck()
        cardsInPlay.removeAll()
        dealCards(count: 12)
        // 初始化已选择和已matched的list
        matchedCards.removeAll()
        selectedCards.removeAll()
    }
    
    // 判断选中的三张卡片是否构成Set的方法
    private func isSet(_ cards: [Card]) -> Bool {
        if cards.count != 3 {return false}
        // Set 是一种集合类型，它用于存储唯一的值，用来去重
        // map用来对cards中的每一个元素进行同样的操作
        let symbolSet = Set(cards.map{$0.symbol})
        let colorSet = Set(cards.map{$0.color})
        let numberSer = Set(cards.map{$0.number})
        let shadingSet = Set(cards.map{$0.shading})
        
        // 如果3张牌完全不同，或者3张牌在某一个/一些属性上有相同的即为set
        // 不能出现只有2张牌在一个/一些属性上有相同的存在
        // 也就是说上面的set应该都是1(3张在这个属性上完全相同)或者3(3张完全不同)
        let isSet = (symbolSet.count == 1 || symbolSet.count == 3) &&
                    (colorSet.count == 1 || colorSet.count == 3) &&
                    (numberSer.count == 1 || numberSer.count == 3) &&
                    (shadingSet.count == 1 || shadingSet.count == 3)
        return isSet
    }
    
    // 替换或移除已匹配的卡片
    private func replaceOrRemoveMatchedCards() {
        for card in selectedCards{
            // 如果在牌桌上能找到这张牌，移除它，并且补充它
            if let index = cardsInPlay.firstIndex(where: {$0.id == card.id}){
                cardsInPlay[index].isSelected = false
                cardsInPlay[index].isSet = true
                // 如果牌堆没空，补充牌
                if !deck.isEmpty{
                    cardsInPlay[index] = deck.popLast()!
                }else{
                    cardsInPlay.remove(at: index)
                }
            }
        }
    }
}


struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
    let id: UUID  // 每张卡片的唯一标识符
    let symbol: Symbol
    let color: Color
    let number: Number
    let shading: Shading
    var isSelected: Bool = false
    var isSet: Bool = false

    // 枚举类型定义卡片的属性
    // CaseIterable 是一个协议，
    // 用于让枚举类型自动生成一个包含所有枚举情况的集合。
    // 这在需要遍历所有枚举情况或统计枚举情况数量时非常有用。
    // 比如我们在后面要用allCase遍历
    enum Symbol: CaseIterable {
        case diamond
        case rectangle
        case oval
    }

    enum Color: CaseIterable {
        case red
        case green
        case purple
    }

    // 如果不显式指定 case one = 1，
    // 编译器会自动从 0 开始为枚举成员分配整数原始值。
    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }

    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
    
    var debugDescription: String{
        "\(id): \(symbol) \(number) \(shading)"
    }

    // 生成所有可能的卡片组合
    // 放在结构体内部能够简化访问，并且让代码更具可读性和组织性。
    // generateDeck 方法被明确地与 Card 类型绑定在一起，
    // 表明它是 Card 类型的一个附属功能，而不是一个通用的外部函数。
    static func generateDeck() -> [Card] {
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
