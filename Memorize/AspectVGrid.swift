//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Qiru on 2024-07-30.
//

import SwiftUI

// item是dont care类型
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    // 这里的item是cards
    var items: [Item]
    var aspectRatio: CGFloat = 1
    // function return a view （因为view不是type是protocol，但是可以包装成dont care）
    // 这个是在EmojiMemoryGameView里头传过来的
    var content: (Item) -> ItemView
    
    // @escaping 闭包会在函数返回后某个时间点执行，而不是立即执行。
    // 这里的 content 被标记为 @escaping，因为它会在 AspectVGrid 的 body 中被多次调用，而不仅仅是在初始化时调用。这意味着 content 闭包在初始化 AspectVGrid 之后的生命周期中可能会被多次使用和调用。
    // 用ViewBuilder允许content返回不同的view而不仅仅是some view
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content:
        @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View{
        // GeometryReader获取容器的尺寸信息，然后传递给 gridItemWidthThatFits 函数来计算每个网格项的宽度。
        GeometryReader{ geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0){
                // 为每张card创建视图
                ForEach(items){item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
        
        
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat{
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat{
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount <= count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
