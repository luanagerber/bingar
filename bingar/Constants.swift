//
//  Constants.swift
//  bingar
//
//  Created by Luana Gerber on 11/03/25.
//

import SwiftUI
import SpriteKit

struct BingoTitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
    }
}

struct BingoNumber: View {
    let number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.title)
            .fontWeight(.regular)
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
    }
}

struct BingoSymbol: View {
    let symbol: String
    
    var body: some View {
        Text(symbol)
            .font(.title)
            .fontWeight(.regular)
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
    }
}
