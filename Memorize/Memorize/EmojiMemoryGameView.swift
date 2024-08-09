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
                .foregroundColor(.orange)
            HStack{
                score
                Spacer()
                shuffle
            }
        }
        // 增加内边距
        .padding()
    }
    
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
                CardView(card)
            // 这里就是content那个closure function啦
                    // 设置宽高比
                    // 增加内边距 
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causeBy: card)))
                    // 点击卡片调用 choose 方法
                    .onTapGesture {
                        withAnimation{
                            viewModel.choose(card)
                        }
                    }
            }
    }
    
    var title: some View{
            // 设置字体大小
            Text("Memorize!")
            .font(.largeTitle)
    }

    private func scoreChange(causeBy card: Card) -> Int{
        return 0
    }
}


struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
