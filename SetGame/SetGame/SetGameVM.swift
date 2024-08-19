//
//  SetGameVM.swift
//  SetGame
//
//  Created by Qiru on 2024-08-15.
//

import Foundation
import SwiftUI

// ViewModel 负责管理 Model 与 View 之间的数据交互
class SetGameVM: ObservableObject{
    // 使用 @Published 来让 View 自动响应数据变化
    // @Published属性包装器，表示当model发生变化时，会自动通知观察者。
    // 后面是包装了model也就是SetGame
    @Published private var setGame: SetGame
    
    // 初始化 ViewModel 时创建一个新的 SetGame 实例
    init() {
        setGame = SetGame()
    }
    
    // 公开模型中当前在游戏中的卡片数组，使 View 可以访问和展示
    var cards: [Card]{
        setGame.cardsInPlay
    }
    
    // 用户点击“deal 3 more cards”按钮
    func dealThreeMoreCards(){
        setGame.dealThreeCards()
    }
    
    // 用户点击“new game”按钮
    func newGame(){
        setGame.startNewGame()
    }
    
    // 用户点击卡片
    func chooseCard(_ card: Card){
        setGame.chooseCard(card: card)
    }
}
