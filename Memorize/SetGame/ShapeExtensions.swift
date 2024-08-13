//
//  ShapeExtensions.swift
//  Memorize
//
//  Created by Qiru on 2024-08-12.
//

import Foundation
import SwiftUI

// Diamond 形状，用于展示菱形符号
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))  // 从顶部中间开始
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))  // 画到右边中间
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))  // 画到底部中间
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))  // 画到左边中间
        path.closeSubpath()  // 关闭路径，回到起点
        return path
    }
}

// Oval 形状，用于展示椭圆符号
struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let ovalRect = CGRect(x: rect.minX, y: rect.midY - rect.height * 0.25, width: rect.width, height: rect.height * 0.5)
        return Path(ellipseIn: ovalRect)  // 绘制一个在矩形内部的椭圆
    }
}

// Rectangle 形状，用于展示矩形符号（SwiftUI 已有的形状，不需要自定义）

// Rectangle 和 Diamond 可以使用 SwiftUI 内置的 Rectangle 形状
// 而 Oval 和 Diamond 由于不是系统默认的形状，因此需要自定义

struct ShapeExtensions_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Diamond()
                .stroke(Color.red, lineWidth: 2)
                .frame(width: 100, height: 100)
            Oval()
                .stroke(Color.green, lineWidth: 2)
                .frame(width: 100, height: 100)
        }
    }
}

