//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Qiru on 2024-08-09.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    var body: some View {
        if number != 0{
            // same as ("\(number)")
            // .sign用来显示正负号, always才会有+号
            Text(number, format: .number.sign(strategy: .always() ))
                .font(.largeTitle)
                .foregroundColor(number < 0 ? .red : .green)
            // 添加阴影效果， 模糊半径， 偏移量
                .shadow(color: .black, radius: 1.5, x:1, y:1)
                .offset(x: 0, y: offset)
            // 如果有flying number往上飞了之后就fading消失
                .opacity(offset != 0 ? 0 : 1)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        // 如果是正数往上offset 200，反之下移200，注意swift的上下是反的
                        offset = number < 0 ? 200 : -200
                    }
                }
            // 设置了appear记得设置onDisappear去重制一些参数
            // 否则offset没有重置下次在同一张卡上就不会出现
            // reset back to the zero
                .onDisappear{
                    offset = 0
                }
        }
    }
}

struct FlyingNumber_Previews: PreviewProvider {
    static var previews: some View {
        FlyingNumber(number: 5)
    }
}
