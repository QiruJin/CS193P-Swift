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
        HStack{
            CardView(isFaceUp: true)
            CardView()
            CardView()
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View{
    var isFaceUp: Bool = false
    
    var body: some View {
        ZStack(content: {
            if isFaceUp{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 2)
                Text("💥").font(.largeTitle)
            }
            else{
                RoundedRectangle(cornerRadius: 12)
            }
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
