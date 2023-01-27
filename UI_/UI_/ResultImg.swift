//
//  ResultImg.swift
//  UI_
//
//  Created by Thomas Dierickx on 26/01/2023.
//

import SwiftUI


struct ResultImg: View {
    
    @State var inputImage: [UIImage]
    @State private var imageDragAmounts: [CGSize]
    @State private var scales: [CGFloat]
    
    let minimumScale: CGFloat = -1.0

    init(inputImage: [UIImage]) {
        self._inputImage = State(initialValue: inputImage)
        self._imageDragAmounts = State(initialValue: Array(repeating: CGSize.zero, count: inputImage.count))
        self._scales = State(initialValue: Array(repeating: 1.0, count: inputImage.count))
    }
    
    var body: some View {
        ZStack {
            Image("Background")
            VStack {
                Text("Make your own")
                    .font(.system(size: 20) .weight(.bold))
                    .font(.custom("NunitoSans", size: 20))
                    .foregroundColor(Color("DarkBlue"))
                Text("T-SHIRT")
                    .font(.system(size: 80) .weight(.heavy))
                    .foregroundColor(Color("DarkBlue"))
                Text("Hold on for just a second,\n your pictures are being processed")
                    .font(.system(size: 20) .weight(.regular))
                    .font(.custom("NunitoSans", size: 20))
                    .foregroundColor(Color("DarkBlue"))
                    .padding()
                ZStack {
                    Rectangle()
                        .frame(width: 300, height: 300)
                    ForEach(inputImage.indices, id: \.self) { index in
                        Image(uiImage: self.inputImage[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .offset(self.imageDragAmounts[index])
                            .zIndex(self.imageDragAmounts[index] == .zero ? 0 : 1)
                            .scaleEffect(self.scales[index])
                            .gesture(
                                DragGesture(coordinateSpace: .global)
                                    .onChanged{
                                        self.imageDragAmounts[index] = CGSize(width: $0.translation.width, height: $0.translation.height)
                                    }
                            )
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        self.scales[index] = max(value.magnitude, minimumScale)
                                    }
                            )
                            .clipped()
                    }
                }
            }
        }
    }
}

struct ResultImg_Previews: PreviewProvider {
    @Binding var inputImage: [UIImage]
    static var previews: some View {
        ResultImg(inputImage: [])
    }
}
