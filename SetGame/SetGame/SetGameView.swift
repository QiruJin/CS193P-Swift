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
            SetCardView(card)
                .padding(5)
            // 点击卡片时的逻辑
                .onTapGesture {
                    setVM.chooseCard(card)
                }
        }
    }
    
    // 用来识别不同view中的元素
    // @是property Wrappers的语法标志
    @Namespace private var dealingNamespace
    private let deckWidth: CGFloat = 50
    private let aspectRatio: CGFloat = 2/3
    
    // deck显示未发放的卡牌的牌堆，背面朝上
    private var deck: some View{
        ZStack{
            ForEach(setVM.deck){ card in
                SetCardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
            .onTapGesture {
                setVM.dealThreeMoreCards() // 点击牌堆时发三张牌
            }
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
