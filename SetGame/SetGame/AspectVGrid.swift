//
//  AspectVGrid.swift
//  SetGame
//
//  Created by Qiru on 2024-08-22.
//  根据传入的项目数量和指定的宽高比来动态布局一个垂直网格视图。
//  自适应列布局
//  确保每个项目（例如卡片）都能以给定的宽高比显示，并且尽量填充整个容器



import SwiftUI

//  Item(card)是don't care，要求每一个item符合identifiable协议
//  ItemView
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    
    //  下面这三个var是需要传过来的参数
    var items:[Item]
    //  每个网格的长宽比，1代表正方形
    var aspectRatio: CGFloat = 1
    //  closure, 接收item然后返回一个view
    // （因为view不是type是protocol，但是可以包装成dont care）
    //  这个是在EmojiMemoryGameView里头传过来的
    var content: (Item) -> ItemView
    
    
    // @escaping 闭包会在函数返回后某个时间点执行，而不是立即执行。
    // 这里的 content 被标记为 @escaping，因为它会在 AspectVGrid 的 body 中被多次调用，而不仅仅是在初始化时调用。
    // 这意味着 content 闭包在初始化 AspectVGrid 之后的生命周期中可能会被多次使用和调用。
    init(_ items: [Item], aspectRatio: CGFloat, content: @escaping (Item) -> ItemView){
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View{
        // GeometryReader获取容器的尺寸信息，然后传递给 gridItemWidthThatFits 函数来计算每个网格项的宽度。
        // geometry是GeometryProxy对象，提供容器的size
        GeometryReader{ geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                aspectRatio: aspectRatio)
            // LazyVGrid 只会在需要时才创建和渲染网格项
            // column 定义了网格的列布局。
            // .adaptive 是一种布局方式，它允许列的数量根据可用空间自动调整，确保每个列的宽度至少为 gridItemSize。如果有足够的空间，更多的列将适应布局；如果空间不足，则减少列数。
            // minimum指定了每个网格项的最小宽度为 gridItemSize。
            // 第一个spacing是列之间的间距，第二个是每个grid的行间距
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize),spacing: 0)], spacing: 0){
                // 为每一张卡都通过content这个闭包生成一个card view
                ForEach(items){ item in
                    content(item)
                    // 视图修饰，fit表示按照前面给定的aspectRatio等比例缩小放大
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    // 通过调整columnCount找到合适的列数和行数
    // 然后最适合容器大小和项目数量的网格宽度和高度
    // parameters: count 卡片数量
    // size: 容器大小
    // aspectRatio: 每个grid的长宽比
    // return 宽度
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        aspectRatio: CGFloat
    ) -> CGFloat{
        // 都用CGFloat是为了和CGSize做计算，int和float做计算之前必须转换
        let count = CGFloat(count)
        var columnCount = 1.0
        while columnCount <= count{
            // 先计算现在说需要的每个grid的width
            let width = size.width / columnCount
            // 然后根据已知的width计算height
            let height = width/aspectRatio
            // 再计算现在需要多少行
            // 超出了也算一行
            let rowCount = (count / columnCount).rounded(.up)
            // 判断现在所需要的高度（行数*高度）是否在容器规格内
            // 如果是，说明现在这个宽度合适，
            // 返回宽度，rounded down因为up可能会超出容器
            if size.height >= (height*rowCount){
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        }
        // 如果没找到合适的columnCount，
        // 对比（只有一行）的宽度和 直接用CGSize的高度对应的宽度
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
