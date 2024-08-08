//
//  Cardify.swift
//  Memorize
//
//  Created by Qiru on 2024-08-07.
//

import SwiftUI

struct Cardify: ViewModifier{
    let isFaceUp: Bool
    
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
