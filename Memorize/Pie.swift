//
//  Pie.swift
//  Memorize
//
//  Created by Qiru on 2024-08-07.
//

// SwiftUI用于构建用户界面，
// CoreGraphics用于处理图形绘制。
import SwiftUI
import CoreGraphics

// struct Pie 定义了一个名为Pie的结构体，并使其遵循Shape协议。
// Shape协议要求实现path(in:)方法，用于定义形状的路径。这个在里面实现了 func path()

struct Pie: Shape {
    // 类型为Angle，初始值为.zero，表示开始角度。
    var startAngle: Angle = .zero
    var endAngle: Angle
    var clockwise = true
    
    // 实现了Shape协议要求的path(in:)方法，用于定义形状的路径。参数rect表示绘制区域。
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        
        // 绘制区域的中心点
        let center  = CGPoint(x: rect.midX, y: rect.midY)
        // 计算绘制区域的半径，取宽度和高度中的较小值的一半。
        let radius = min(rect.width, rect.height) / 2
        // 计算扇形起始点的坐标。
        let start = CGPoint(
            // 通过三角函数cos和sin将角度转换为坐标。
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        // 创建一个新的Path对象，Path用于定义形状的路径。
        var p = Path()
        // 将路径的起点移动到中心点。
        p.move(to: center)
        // 从中心点绘制一条线到起始点。
        p.addLine(to: start)
        // 添加一个圆弧，从startAngle到endAngle，
        // 以center为圆心，radius为半径，
        // 根据clockwise确定顺时针还是逆时针方向。
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        // 从结束点绘制一条线回到中心点，形成一个扇形。
        p.addLine(to: center)
        
        return p
    }
}
