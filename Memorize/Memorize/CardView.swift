//
//  CardView.swift
//  Memorize
//
//  Created by Qiru on 2024-08-04.
//

import SwiftUI

// 定义卡片视图结构体，实现 View 协议
struct CardView: View{
    // namespace
    typealias Card = MemoryGame<String>.Card
    
    //    let content: String
    //    @State var isFaceUp = true
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        // 用TimelineView可展示view，minimumInterval不需要每毫秒都有animation，节省资源
        TimelineView(.animation(minimumInterval: 1/5)) { timeline in
            if card.isFaceUp || !card.isMatched{
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                // 用modifier可以有更多的动画？
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.opacity)
            } else {
                // 尽管卡片消失，但仍然有占位
                Color.clear
            }
        }

    }
    
    var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .aspectRatio(1, contentMode: .fit)
            .multilineTextAlignment(.center)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
        // only to affect rotationEffect animation: add duration
        // autoreverse: false 是为了一直转圈圈而不是转一下反方向继续转
        // implicit 和 explicit互相independent不影响
            .animation(.spin(duration: 1), value: card.isMatched)
    }
    private struct Constants{
        static let inset : CGFloat = 5
        struct FontSize {
            static let largest : CGFloat = 200
            static let smallest : CGFloat = 10
            static let scaleFactor : CGFloat = smallest / largest
        }
        struct Pie{
            static let opacity : CGFloat = 0.4
            static let inset : CGFloat = 5
        }
    }
}

extension Animation{
    static func spin(duration : TimeInterval) -> Animation{
        .easeInOut(duration: duration).repeatForever(autoreverses: false)
    }
}

struct CardView_Previews: PreviewProvider {
    // namespace, 这是card View的preview可以这么用？
    typealias Card = CardView.Card
    
    static var previews: some View {
        VStack{
            HStack{
                CardView(Card(isFaceUp: true, content: "X", id: "test1"))
                    .aspectRatio(4/3, contentMode: .fit)
                CardView(Card(content: "X", id: "test1"))
            }
            HStack{
                CardView(Card(isFaceUp: true, content: "This is a very long string and I hope it fits", id: "test1"))
                CardView(Card(isMatched: true, content: "X", id: "test1"))
            }
        }
        .padding()
        .foregroundColor(.green)
    }
}
