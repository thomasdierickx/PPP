//
//  ContentView.swift
//  UI_
//
//  Created by Thomas Dierickx on 19/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("Background")
            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
                Text("Make your own")
                    .font(.system(size: 25) .weight(.bold))
                    .font(.custom("NunitoSans", size: 25))
                    .foregroundColor(Color("DarkBlue"))
                Text("T-SHIRT")
                    .font(.system(size: 86) .weight(.heavy))
                    .foregroundColor(Color("DarkBlue"))
                GeometryReader { geometry in
                    ImageCarouselView(numberOfImages: 3) {
                        Image("T-shirt1")
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        Image("T-shirt2")
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        Image("T-shirt3")
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }.frame(width: 400, height: 450, alignment: .center)
                Button(action: { }) {
                    Text("BEGIN")
                        .font(.system(size: 20) .weight(.bold))
                        .foregroundColor(Color("White"))
                }
                .frame(maxWidth: 300, maxHeight: 50)
                .background(Color("LightBlue"))
                .cornerRadius(30)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
