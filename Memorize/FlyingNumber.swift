//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Qiru on 2024-08-09.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    var body: some View {
        if number != 0{
            // same as ("\(number)")
            Text(number, format: .number)
        }
    }
}

struct FlyingNumber_Previews: PreviewProvider {
    static var previews: some View {
        FlyingNumber(number: 5)
    }
}
