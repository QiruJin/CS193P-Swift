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
class SetGame: ObservableObject{
    
    @Published private(set) var deck: [Card]
    @Published private(set) var cardsInPlay: [Card] = []
    @Published private(set) var selectedCards: [Card] = []
    @Published private(set) var matchedCards: [Card] = []
    
}

struct Card: Equatable, Identifiable, CustomDebugStringConvertible{
    
    let id: UUID
    let symbol: Symbol
    let color: Color
    let number: Number
    let shading: Shading
    var isSeleted: Bool = false
    var isMatched: Bool = false
    
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
        "\(id): \(symbol) \(number) \(shading)"
    }

}

