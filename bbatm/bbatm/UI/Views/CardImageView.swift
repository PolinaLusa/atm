//
//  CardImageView.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import SwiftUI

struct CardImageView: View {
    let imageName: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 40)
                    .padding(4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(self.colorScheme == .dark ? .gray : Color(uiColor: .lightGray), lineWidth: 2)
                    )
                Spacer()
            }
        }
    }
}

#Preview {
    CardImageView(imageName: "Mir")
}
