//
//  ContentView.swift
//  Memorize
//
//  Created by Qiru on 2024-06-26.
//

import SwiftUI

struct ContentView: View {
    // VStack：up and down, vertical stack
    // HStack: side to side, horizontal
    // ZStack: direction towards the user
    var body: some View {
        // Array<String> same as [String]
        let emojis: Array<String> = ["👻", "🎃", "🕷", "😈"]
        HStack{
            // ... means includes 4, ..< means 4 is not include
            // we can use forEach(0..<4) as well
            ForEach(emojis.indices, id: \.self){
                index in
                CardView(content: emojis[index])
            }
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View{
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack{
            // type inference
            let base: RoundedRectangle = RoundedRectangle(cornerRadius: 12)
            if isFaceUp{
                base.foregroundColor(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            else{
                base.fill()
            }
        }
        .onTapGesture{
            isFaceUp.toggle() // for bool, f to t, t to f
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
