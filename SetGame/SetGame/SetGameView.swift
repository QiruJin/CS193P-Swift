//
//  SetGameView.swift
//  SetGame
//
//  Created by Qiru on 2024-08-19.
//

import SwiftUI

struct SetGameView: View {
    
    // 声明一个被观察的对象 viewModel，它是 EmojiMemoryGame 类型的实例，负责提供数据和业务逻辑。
    @ObservedObject var setVM: SetGameVM
    
    var body: some View {
        VStack{
            title
            
            HStack{
                threeMoreCard
                Spacer()
                newGame
            }
        }
    }
    
    var title: some View{
        Text("Set Game")
            .font(.largeTitle)
    }
    
    var newGame: some View{
        Button("New Game"){
            setVM.newGame()
        }
    }
    
    var threeMoreCard: some View{
        Button("Add 3 Cards"){
            setVM.dealThreeMoreCards()
        }
    }
    
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(setVM: SetGameVM())
    }
}
