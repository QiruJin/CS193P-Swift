//
//  SetCardView.swift
//  Memorize
//
//  Created by Qiru on 2024-08-12.
//

import SwiftUI

// 用于展示 Set 游戏中的卡片内容
struct SetCardView: View {
    
    typealias Card = SetGameVM.Card
    let card: Card  // 传入的卡片数据
    
    init(_ card: Card) {
        self.card = card
    }

    var body: some View {
        GeometryReader { geometry in  // 使用 GeometryReader 获取卡片的尺寸信息
            ZStack {
                backgroundRectangle
                symbolView(geometry: geometry)
            }
            .padding(5)  // 给卡片内容添加一些内边距
        }
    }
    
    var backgroundRectangle: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)  // 设置卡片背景为白色
                .shadow(radius: 5)  // 添加阴影效果
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 3)  // 给卡片添加边框
                .foregroundColor(card.isSeleted ? .blue : .gray)  // 如果卡片被选中，边框为蓝色，否则为灰色
        }
    }
    
    func symbolView(geometry: GeometryProxy) -> some View{
        VStack {
            // 根据卡片信息(number)决定symbol的数量
            
            // 在使用 ForEach 时，id 参数是用来指定每个生成的视图的唯一标识符。
            // 对于简单的数据类型（如整数、字符串）
            // \.self 表示使用元素本身作为标识符
            ForEach(0..<card.number.rawValue, id: \.self) { _ in
                symbol(for: card)
                    // 设置符号颜色
                    .foregroundColor(colorForCard(card))
                    // 如果是条纹样式，则降低不透明度
                    .opacity(opacityForCard(card))
                    // 设置符号的大小
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.2)

            }
        }
    }
    // 根据卡片的属性返回对应的符号视图
    // @ViewBuilder 允许在一个函数中返回多个视图或条件视图
    @ViewBuilder
    private func symbol(for card: Card) -> some View {
        switch card.symbol {
        // 检查一个 Symbol 类型的值时，可以直接使用 .diamond 等简化写法，
        // swift可以自己腿短，不必写全 Symbol.diamond
        case .diamond:
            Diamond()
        case .rectangle:
            Rectangle()
        case .oval:
            Oval()
        }
    }
    
    // 根据卡片的颜色属性返回对应的颜色
    private func colorForCard(_ card: Card) -> Color {
        switch card.color {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
    
    // 根据卡片的shading属性返回对应的透明度
    private func opacityForCard(_ card: Card) -> CGFloat {
        switch card.shading {
        case .striped: return 0.3
        case .open: return 0.1
        case .solid: return 1
        }
    }
}

// 自定义 Preview，用于预览卡片视图
struct SetCardView_Previews: PreviewProvider {
    typealias Card = SetGameVM.Card
    static var previews: some View {
        VStack{
            HStack{
                SetCardView(Card(id: UUID(), symbol: .diamond, color: .red, number: .three, shading: .solid))
                    .frame(width: 100, height: 150)  // 设置预览中卡片的大小
                SetCardView(Card(id: UUID(), symbol: .oval, color: .green, number: .one, shading: .open))
                    .frame(width: 100, height: 150)  // 设置预览中卡片的大小
            }
            HStack{
                SetCardView(Card(id: UUID(), symbol: .rectangle, color: .purple, number: .two, shading: .striped))
                    .frame(width: 100, height: 150)
            }
        }
    }
}

