//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Qiru on 2024-06-26.
//

// View
// 展示数据和处理用户交互。EmojiMemoryGameView展示卡片并响应用户操作，通过ViewModel更新数据。

import SwiftUI

// 定义 EmojiMemoryGameView 结构体，实现 View 协议
struct EmojiMemoryGameView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    // 声明一个被观察的对象 viewModel，它是 EmojiMemoryGame 类型的实例，负责提供数据和业务逻辑。
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    // @State不能在body里面声明，因为是用来管理View的状态
    @State var cardCount: Int = 12
    @State var emojis: Array<String> = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺"]
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 5
    
    var body: some View {
        VStack{
            // 标题视图
            title
            // cards视图，添加animation
            cards
                .animation(.default, value: viewModel.cards)
            // 设置前景色
                .foregroundColor(viewModel.color)
            HStack{
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
                Spacer()
                shuffle
            }
        }
        // 增加内边距
        .padding()
    }
        
    // tuple type
    // 跟踪最近一次分数变化及其原因
    // @State能够自动监测
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private var score : some View{
        Text("Score: \(viewModel.score)")
        // do not animate this view
            .animation(nil)
    }
    
    // 洗牌按钮，调用 viewModel 的 shuffle 方法
    private var shuffle : some View{
        Button("Shuffle"){
            withAnimation{viewModel.shuffle()}
        }
    }

    // 定义cards视图
    private var cards: some View{
            // let width = geometry.size.width / 4 - 8
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio){ card in
            if isDealt(card){
                view(for: card)
            // 这里就是content那个closure function啦
                    // 设置宽高比
                    // 增加内边距
                    .padding(spacing)
                    // 添加覆盖层显示得分
                    .overlay(FlyingNumber(number: scoreChange(causeBy: card)))
                    // zIndex越大视图就在越前面，如果这张卡片造成score变化，zIndex变大
                     .zIndex(scoreChange(causeBy: card) != 0 ? 1 : 0)
                    // 点击卡片调用 choose 方法
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    // 用来识别不同view中的元素
    // @是property Wrappers的语法标志
    @Namespace private var dealingNamespace
    
    private func view(for card: Card) -> some View {
        CardView(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    // a deck use to deal the card
    private var deck: some View{
        ZStack{
            ForEach(undealtCards) {card in
                CardView(card)
                // 让两个view共享一个animation
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal(){
        var delay: TimeInterval = 0
        // deal the cards
        for card in viewModel.cards{
            withAnimation(dealAnimation.delay(delay)){
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50
    
    var title: some View{
            // 设置字体大小
            Text("Memorize!")
            .font(.largeTitle)
    }

    // choose card时的动画变化，可以直接复制粘贴到cards中，但是提出来简化代码
    private func choose(_ card: Card){
        withAnimation{
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    // 只有在卡片是导致分数变化的那一张时显示分数 
    private func scoreChange(causeBy card: Card) -> Int{
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}


struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
