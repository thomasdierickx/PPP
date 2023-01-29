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
    
    var zStackView: some View {
        ZStack {
            Rectangle()
                .frame(width: 300, height: 300)
                .foregroundColor(selectedColor)
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
    
    let minimumScale: CGFloat = -1.0

    init(inputImage: [UIImage]) {
        self._inputImage = State(initialValue: inputImage)
        self._imageDragAmounts = State(initialValue: Array(repeating: CGSize.zero, count: inputImage.count))
        self._scales = State(initialValue: Array(repeating: 1.0, count: inputImage.count))
    }
    
    @State private var showingAlert = false
    @State private var squareDimension = 30
    @State private var cornerRadius = 10
    
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
                Text("Personalize your composition \n & save it!")
                    .font(.system(size: 20) .weight(.regular))
                    .font(.custom("NunitoSans", size: 20))
                    .foregroundColor(Color("DarkBlue"))
                    .padding()
                zStackView
                HStack {
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.black)
                        .onTapGesture {
                            self.selectedColor = .black
                        }
                        .padding(.trailing, 10)
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.green)
                        .onTapGesture {
                            self.selectedColor = .green
                        }
                        .padding(.trailing, 10)
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.selectedColor = .blue
                        }
                        .padding(.trailing, 10)
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.white)
                        .onTapGesture {
                            self.selectedColor = .white
                        }
                        .padding(.trailing, 10)
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.selectedColor = .red
                        }
                        .padding(.trailing, 10)
                    RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                        .frame(width: CGFloat(squareDimension), height: CGFloat(squareDimension))
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            self.selectedColor = .yellow
                        }
                        .padding(.trailing, 10)
                }
                .padding()
                Button("Save to image") {
                    let image = zStackView.snapshot()

                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.showingAlert = true
                }
                NavigationLink(destination: TshirtView(globalImage: globalImage)) {
                    Button(action: {}) {
                        Text("SOW ON T-SHIRT")
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
