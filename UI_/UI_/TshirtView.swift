//
//  TshirtView.swift
//  UI_
//
//  Created by Thomas Dierickx on 29/01/2023.
//

import SwiftUI
import CoreML
import Vision

struct TshirtView: View {
    
    @State var globalImage: UIImage
    @State var colorToImage: UIImage
    @State private var squareDimension = 30
    @State private var cornerRadius = 10
    @State private var showingAlert = false
    @State private var selectedColor: Color? = nil
    
    let colorName = ["ResultBlack", "ResultBlue", "ResultGreen", "ResultHotPink", "ResultRed", "ResultWhite"]
    
    let colorMap: [String: Color] = [
        "ResultBlack": .black,
        "ResultBlue": .blue,
        "ResultGreen": .green,
        "ResultHotPink": .pink,
        "ResultRed": .red,
        "ResultWhite": .white
    ]
    
    var vStackView : some View {
        ZStack{
            if (colorToImage.imageAsset == nil) {
                Image("ResultBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
            } else {
                Image(uiImage: colorToImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
            }
            VStack {
                Image(uiImage: self.globalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }.padding(.top, -30)
        }
    }
    
    var roundedRectangle: some View {
        HStack {
            ForEach(colorName.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                    .foregroundColor(colorMap[colorName[index]] ?? .black)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        self.selectedColor = colorMap[colorName[index]]
                        self.colorToImage = UIImage(named: colorName[index])!
                    }
            }
        }.padding()
    }
    
    var body: some View {
        ZStack {
            Image("Background")
            VStack {
                vStackView
                roundedRectangle
                Button("Save to image") {
                    let image = vStackView.snapshot()

                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text("The image has been saved to your photo album"), dismissButton: .default(Text("OK")))
        }
    }
}

struct TshirtView_Previews: PreviewProvider {
    @Binding var globalImage: UIImage
    static var previews: some View {
        TshirtView(globalImage: UIImage(), colorToImage: UIImage())
    }
}
