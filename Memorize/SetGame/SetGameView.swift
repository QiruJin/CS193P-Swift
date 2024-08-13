//
//  SetGameView.swift
//  Memorize
//
//  Created by Qiru on 2024-08-12.
//

import SwiftUI

struct SetGameView: View {
    // 声明一个被观察的对象 viewModel，它是 EmojiMemoryGame 类型的实例，负责提供数据和业务逻辑。
    @ObservedObject var setVM: SetGameViewModel
    
    var body: some View {
        VStack{
            title
            cards
            
            HStack{
                dealMoreCards
                Spacer()
                newGame
            }
        }
        .padding(5)
    }

    private var cards : some View{
        AspectVGrid(setVM.cards, aspectRatio: 2/3){ card in
            SetCardView(card)
                .padding(5)
                .onTapGesture {
                    setVM.chooseCard(card)
                }
        }
    }
    
    private var dealMoreCards : some View{
        Button("Deal 3 Cards"){
            setVM.dealThreeMoreCards()
        }
    }
    
    private var newGame : some View{
        Button("New Game"){
            setVM.newGame()
        }
    }
    
    var title : some View{
        Text("SET")
            .font(.largeTitle)
    }
    
}


struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(setVM: SetGameViewModel())
    }
}
