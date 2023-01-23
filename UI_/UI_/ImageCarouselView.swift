//
//  ImageCarouselView.swift
//  ImageCarousel
//
//  Created by Thomas Dierickx on 19/01/2023.
//

import SwiftUI
import Combine

struct ImageCarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content
    @State var slideGesture: CGSize = CGSize.zero
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            // 1
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    self.content
                }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                    .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                    .animation(.spring())
                    // Comment .onReceive method, to omit the Slider with time
                    .onReceive(self.timer) { _ in
                        self.currentIndex = (self.currentIndex + 1) % (self.numberOfImages == 0 ? 1 : self.numberOfImages)}
                    // Comment .gesture method, to omit the Swipe function
                    .gesture(DragGesture().onChanged{ value in
                        self.slideGesture = value.translation
                    }
                                .onEnded{ value in
                        if self.slideGesture.width < -50 {
                            if self.currentIndex < self.numberOfImages - 1 {
                                withAnimation {
                                    self.currentIndex += 1
                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.currentIndex > 0 {
                                withAnimation {
                                    self.currentIndex -= 1
                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
                
                // 2
                HStack(spacing: 8) {
                    // 3
                    ForEach(0..<self.numberOfImages, id: \.self) { index in
                         // 4
                        Circle()
                            .frame(width: index == self.currentIndex ? 10 : 8,
                                   height: index == self.currentIndex ? 10 : 8)
                            .foregroundColor(index == self.currentIndex ? Color("LightBlue") : .white)
                            .overlay(Circle().stroke(Color("LLBlue"), lineWidth: 1))
                            .padding(.top, 15)
                            .animation(.spring())
                    }
                }
            }
        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ImageCarouselView(numberOfImages: 3) {
                Image("T-shirt1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Image("T-shirt2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Image("T-shirt3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }.frame(width: 400, height: 450, alignment: .center)
    }
}
