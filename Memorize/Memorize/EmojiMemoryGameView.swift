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
    
    // VStack：up and down, vertical stack
    // HStack: side to side, horizontal
    // ZStack: direction towards the user
    // Array<String> same as [String]
    let emojisHalloween: Array<String> = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺"]
    let emojisPeople: Array<String> = ["👶🏻", "👧🏻", "💂🏻‍♀️", "👮🏻‍♀️", "👩🏻‍⚕️", "👩🏻‍🌾", "👩🏻‍💻", "👩🏻‍🎓"]
    let emojisFood: Array<String> = ["🥐", "🥯", "🥨", "🌯", "🥟", "🍨", "🍫", "🍲"]
    let emojisAnimal: Array<String> = ["🐶", "🦁", "🐷", "🦊", "🐰", "🐼", "🐵", "🐸"]
    
    // @State不能在body里面声明，因为是用来管理View的状态
    @State var cardCount: Int = 12
    @State var emojis: Array<String> = ["👻", "🎃", "🕷", "😈", "👾", "👁", "🧛🏼", "👺"]
    var body: some View {
        VStack{
            // 标题视图
            title
            ScrollView{
                // cards视图，添加animation
                cards
                    .animation(.default, value: viewModel.cards)
            }
            // 洗牌按钮，调用 viewModel 的 shuffle 方法
            Button("Shuffle"){
                viewModel.shuffle()

            }
//            Spacer()
//            themesAdjusters
        }
        // 增加内边距
        .padding()
    }
    
    // 定义cards视图
    var cards: some View{
        GeometryReader{ geometry in
            // let width = geometry.size.width / 4 - 8
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0){
                // 为每张card创建视图
                ForEach(viewModel.cards){ card in
                    CardView(card)
                        // 设置宽高比
                        .aspectRatio(2/3, contentMode: .fit)
                        // 增加内边距
                        .padding(4)
                        // 点击卡片调用 choose 方法
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
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
    
    // 定义主题调整视图
    // @discard
    var themesAdjusters: some View{
        HStack{
            themesHalloween
            Spacer()
            themesFood
            Spacer()
            themesAnimal
            Spacer()
            themesPeople
        }
        .imageScale(.medium)
        .font(.largeTitle)
    }
    
    // 定义各个主题的按钮视图
    // @discard
    var themesHalloween: some View{
        return themesAdjuster(by: "Halloween", symbol: "sun.max.trianglebadge.exclamationmark.fill")
    }
    var themesFood: some View{
        return themesAdjuster(by: "Food", symbol: "carrot")
    }
    var themesAnimal: some View{
        return themesAdjuster(by: "Animal", symbol: "pawprint")
    }
    var themesPeople: some View{
        return themesAdjuster(by: "People", symbol: "person")
    }

    // 定义主题调整器函数
    // @discard
    func themesAdjuster(by theme: String, symbol: String) -> some View{
        Button(action: {
            emojisAdjuster(of: theme)
        }){
            VStack{
                Image(systemName: symbol)
                    .font(.title)
                Text(theme)
                    .font(.caption)
            }
            .foregroundColor(.orange)
        }
    }

    // 定义卡片数量调整视图
    // @discard
    var cardsCountAdjusters: some View{
        HStack{
            cardRemover
            Spacer() // have space between
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }

    // 定义卡片数量调整器函数
    // @discard
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View{
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }

    // 定义减少卡片数量按钮
    // @discard
    var cardRemover: some View{
        return cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }

    // 定义增加卡片数量按钮
    // @discard
    var cardAdder: some View{
        return cardCountAdjuster(by: 1, symbol: "rectangle.stack.badge.plus.fill")
    }
    
    // 定义表情调整器函数
    // @discard
    func emojisAdjuster(of theme: String){
        switch theme{
        case "Halloween":
            emojis = arrayAdjuster(emojisHalloween)
        case "People":
            emojis = arrayAdjuster(emojisPeople)
        case "Animal":
            emojis = arrayAdjuster(emojisAnimal)
        case "Food":
            emojis = arrayAdjuster(emojisAnimal)
        default:
            emojis = arrayAdjuster(emojisAnimal)
        }
    }
    
    // 定义数组调整器函数
    // @discard
    func arrayAdjuster(_ emojisArray: Array<String>) -> Array<String>{
        cardCount = min(cardCount, emojisArray.count * 2)
        let afterShuffled = emojisArray.shuffled()
        let arraySliced = Array(afterShuffled.prefix(cardCount/2))
        let afterSliced = arraySliced + arraySliced
        return afterSliced.shuffled()
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
