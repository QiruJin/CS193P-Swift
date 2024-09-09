//
//  SetGameView.swift
//  SetGame
//
//  Created by Qiru on 2024-08-19.
//

import SwiftUI

struct SetGameView: View {
    
    // 声明一个被观察的对象 viewModel，它是 EmojiMemoryGame 类型的实例，负责提供数据和业务逻辑。
    @ObservedObject var setVM: SetGameVM
    typealias Card = SetGameVM.Card
    
    var body: some View {
        VStack{
            // HStack{title, discard pile}
            title
            cards
            HStack{
                // deck instead of +3
                deck
                Spacer()
                shuffle
                Spacer()
                newGame
            }
        }
    }
    
    private var cards: some View{
        AspectVGrid(setVM.cards, aspectRatio: 2/3){ card in
            if isDealt(card){
                SetCardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(5)
                // 点击卡片时的逻辑
                    .onTapGesture {
                        setVM.chooseCard(card)
                    }
            }
        }
    }
    
    // 用来识别不同view中的元素
    // @是property Wrappers的语法标志
    @Namespace private var dealingNamespace
    private let deckWidth: CGFloat = 50
    private let aspectRatio: CGFloat = 2/3
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    
    // deck显示未发放的卡牌的牌堆，背面朝上
    private var deck: some View{
        ZStack{
            ForEach(setVM.deck){ card in
                // 卡牌背面效果
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cyan)
                    Text("?")
                        .font(.largeTitle)
                }
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
            .onTapGesture {
                    dealThreeCards()
            }
        }
    }
    
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card.id)
    }
    
    // add cardsInDisplay into dealt to make sure it will appear in th beginning
    private func initializeDealtCards() {
        dealCards(setVM.cards)
    }
    
    private func dealThreeCards(){
        // deal the cards
        setVM.dealThreeMoreCards()
        dealCards(setVM.cardsToDeal)
    }
    
    private func dealCards(_ cards: [Card]){
        var delay: TimeInterval = 0
        // deal the cards
        for card in cards{
            withAnimation(dealAnimation.delay(delay)){
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    // internal,可以被外部代码访问
    var title: some View{
        Text("Set Game")
            .font(.largeTitle)
    }
    
    var newGame: some View{
        Button("New Game"){
            setVM.newGame()
        }
    }
    
    var shuffle: some View{
        Button("Shuffle"){
            setVM.shuffle()
        }
    }
    
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(setVM: SetGameVM())
    }
}
