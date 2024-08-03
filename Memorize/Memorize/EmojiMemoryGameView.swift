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
    
    // 声明一个被观察的对象 viewModel，它是 EmojiMemoryGame 类型的实例，负责提供数据和业务逻辑。
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    // @State不能在body里面声明，因为是用来管理View的状态
    @State var cardCount: Int = 12
    @State var emojis: Array<String> = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺"]
    private let aspectRatio: CGFloat = 2/3
    var body: some View {
        VStack{
            // 标题视图
            title
            // cards视图，添加animation
            cards
                .animation(.default, value: viewModel.cards)
            // 洗牌按钮，调用 viewModel 的 shuffle 方法
            Button("Shuffle"){
                viewModel.shuffle()

            }
        }
        // 增加内边距
        .padding()
    }
    
    // 定义cards视图
    private var cards: some View{
            // let width = geometry.size.width / 4 - 8
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio){ card in
                CardView(card)
            // 这里就是content那个closure function啦
                    // 设置宽高比
                    // 增加内边距 
                    .padding(4)
                    // 点击卡片调用 choose 方法
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        // 设置前景色
        .foregroundColor(.orange)
    }
    
    var title: some View{
            // 设置字体大小
            Text("Memorize!")
            .font(.largeTitle)
    }
  
}

// 定义卡片视图结构体，实现 View 协议
struct CardView: View{
//    let content: String
//    @State var isFaceUp = true
    
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack{
            // type inference
            let base: RoundedRectangle = RoundedRectangle(cornerRadius: 12)
            base.frame(width:10, height: 50)
            Group{
                base.foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            // 卡片正面显示
            .opacity(card.isFaceUp ? 1 : 0)
            // 卡片反面显示
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        // opacity是SwiftUI中的一个修饰符，用于设置视图的透明度，其值范围在0到1之间：
        // 1表示完全不透明（视图完全可见）,0表示完全透明（视图不可见）。
        // 也就是背面&已经match的卡片们不可见
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)

//        .onTapGesture{
//            isFaceUp.toggle() // for bool, f to t, t to f
//        }
    }
}
struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
