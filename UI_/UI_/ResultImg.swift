//
//  ResultImg.swift
//  UI_
//
//  Created by Thomas Dierickx on 26/01/2023.
//

import SwiftUI

var globalImage: UIImage = UIImage()

struct ResultImg: View {
    
    @State var inputImage: [UIImage]
    @State private var imageDragAmounts: [CGSize]
    @State private var scales: [CGFloat]
    @State private var selectedColor = Color.black
    @State private var showingAlert = false
    @State private var squareDimension = 30
    @State private var cornerRadius = 10
    let minimumScale: CGFloat = -1.0
    let text: String = ""
    @State private var text2DragAmount = CGSize.zero
    
    @State private var selection = "Explosion"
    let backgroundImage = ["Explosion", "Electric", "Cash", "American Flag", "None"]

    init(inputImage: [UIImage]) {
        self._inputImage = State(initialValue: inputImage)
        self._imageDragAmounts = State(initialValue: Array(repeating: CGSize.zero, count: inputImage.count))
        self._scales = State(initialValue: Array(repeating: 1.0, count: inputImage.count))
    }
    
    var zStackView: some View {
        ZStack {
            Rectangle()
                .frame(width: 300, height: 300)
                .foregroundColor(selectedColor)
            Image(selection)
                .resizable()
                .scaledToFit()
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
            Text(text2)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged{
                            self.text2DragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                        }
                )
                .offset(text2DragAmount)
        }
    }
    
    var roundedRectangle: some View {
        let colorName = [".black", ".green", ".blue", ".white", ".red", ".yellow"]
        
        let colorMap: [String: Color] = [
            ".black": .black,
            ".green": .green,
            ".blue": .blue,
            ".white": .white,
            ".red": .red,
            ".yellow": .yellow
        ]
        
        return HStack {
            ForEach(colorName.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                    .foregroundColor(colorMap[colorName[index]] ?? .black)
                    .onTapGesture {
                        self.selectedColor = colorMap[colorName[index]] ?? .black
                    }
                    .padding(.trailing, 10)
            }
        }.padding()
    }
    
    @State private var text2 = "Your text here"
    
    var body: some View {
        ZStack {
            Image("Background")
            VStack {
                Text("Make your own")
                    .font(.system(size: 15) .weight(.bold))
                    .font(.custom("NunitoSans", size: 15))
                    .foregroundColor(Color("DarkBlue"))
                Text("T-SHIRT")
                    .font(.system(size: 50) .weight(.heavy))
                    .foregroundColor(Color("DarkBlue"))
                Text("Personalize your composition \n & save it!")
                    .font(.system(size: 20) .weight(.regular))
                    .font(.custom("NunitoSans", size: 20))
                    .foregroundColor(Color("DarkBlue"))
                Picker("Select a background", selection: $selection) {
                    ForEach(backgroundImage, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 300,height: 60)
                zStackView
                roundedRectangle
                TextField("Enter some text", text: $text2)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300, height: 60)
                HStack {
                    Image("download")
                        .frame(width: 50)
                        .background(Color("LightBlue"))
                        .cornerRadius(30)
                        .onTapGesture {
                            let image = zStackView.snapshot()
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            self.showingAlert = true
                        }
                        .padding()
                    NavigationLink(destination: TshirtView(globalImage: globalImage, colorToImage: UIImage())) {
                        Button(action: {}) {
                            Text("SHOW ON T-SHIRT")
                                .font(.system(size: 20) .weight(.bold))
                                .foregroundColor(Color("White"))
                        }
                        .frame(maxWidth: 250, maxHeight: 50)
                        .background(Color("LightBlue"))
                        .cornerRadius(30)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text("The image has been saved to your photo album"), dismissButton: .default(Text("OK")))
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let image = renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        globalImage = image
        return image
    }
}

struct ResultImg_Previews: PreviewProvider {
    @Binding var inputImage: [UIImage]
    static var previews: some View {
        ResultImg(inputImage: [])
    }
}
