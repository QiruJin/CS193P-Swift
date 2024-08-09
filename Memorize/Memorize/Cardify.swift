//
//  Cardify.swift
//  Memorize
//
//  Created by Qiru on 2024-08-07.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable{
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool{
        rotation < 90
    }
    
    // 被 animatableData 属性所操控，从而使得 rotation 可以随着动画的进行而变化。
    var rotation : Double
    
    // 实现 Animatable 协议所必须的属性
    // 在实现 Animatable 协议时，animatableData 属性允许 SwiftUI 的动画系统访问和修改视图的某个或某些属性，以便在动画过程中平滑地过渡。
    // get 用于告诉动画系统当前动画属性的值是什么。
    // set 用于在动画过程中设置新值，让动画效果逐渐完成。
    var animatableData: Double{
        // get computed properties访问器：返回当前的 rotation 值。
        // Animatable 协议使得 rotation 可以随着动画过程逐步从一个值过渡到另一个值，比如从 180 度（背面）过渡到 0 度（正面），或反之。
        get{rotation}
        // set 访问器：将 rotation 设置为新的值 newValue，这个 newValue 是动画系统在动画过程中逐渐变化的数值。
        set{rotation = newValue}
    }
    
    func body(content: Content) -> some View{
        ZStack{
            // type inference
            let base: RoundedRectangle = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            // use background and overlay
            // this is background
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.foregroundColor(.white))
                // this is frontground
                .overlay(content)
                // 卡片正面显示
                .opacity(isFaceUp ? 1 : 0)            
            // 卡片反面显示
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        // (1, 0, 0) 表示绕X轴（水平轴）旋转。
        // (0, 1, 0) 表示绕Y轴（垂直轴）旋转。
        // (0, 0, 1) 表示绕Z轴（深度轴）旋转。
        // 视图会从 180 度（表示背面）逐渐旋转回 0 度（表示正面）。or相反
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private struct Constants{
        static let cornerRadius : CGFloat = 12
        static let lineWidth : CGFloat = 2
    }
}

// 几乎每次都会添加这个extension方便其他地方调用这个api
extension View{
    func cardify(isFaceUp: Bool) -> some View{
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
