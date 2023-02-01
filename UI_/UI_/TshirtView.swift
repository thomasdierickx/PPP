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
    @State private var modelName = ""
    
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
            if (selectedColor == nil) {
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
                vStackView
                roundedRectangle
                Text("Style transfer")
                    .font(.system(size: 20) .weight(.regular))
                    .font(.custom("NunitoSans", size: 20))
                    .foregroundColor(Color("DarkBlue"))
                HStack {
                    Button(action: {
                        let image = vStackView.snapshot()
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        self.showingAlert = true
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("LightBlue"))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image("download")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                            )
                    }
                    Button(action: {
                        modelName = "4"
                        runCoreML(inputImage: self.globalImage, modelName: modelName)
                    }) {
                        Text("Back")
                            .frame(width: 50, height: 50)
                            .background(Color("LightBlue"))
                            .cornerRadius(10)
                            .foregroundColor(Color("White"))
                            .font(.system(size: 15) .weight(.bold))
                    }
                    Button(action: {
                        modelName = "1"
                        runCoreML(inputImage: self.globalImage, modelName: modelName)
                    }) {
                        Image("VGCover")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        modelName = "2"
                        runCoreML(inputImage: self.globalImage, modelName: modelName)
                    }) {
                        Image("PietMondriaan")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        modelName = "3"
                        runCoreML(inputImage: self.globalImage, modelName: modelName)
                    }) {
                        Image("USSR")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text("The image has been saved to your photo album"), dismissButton: .default(Text("OK")))
        }
    }
    
    func runCoreML(inputImage: UIImage, modelName: String) {
        var OGimage = [globalImage]
        
        if (modelName == "4") {
            globalImage = OGimage[0]
            print("Test")
        }

        // Load the Core ML model
        if modelName == "1" {
            guard let model = try? VNCoreMLModel(for: Style1(configuration: .init()).model) else {
                fatalError("Can't load Core ML model")
            }
            
            // Create a request to run the model
            let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
            request.imageCropAndScaleOption = .scaleFill

            // Convert the input image to a CIImage
            let ciInputImage = CIImage(image: inputImage)!
            
            // Create a handler to perform the request
            let handler = VNImageRequestHandler(ciImage: ciInputImage)
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
        if (modelName == "2") {
                guard let model = try? VNCoreMLModel(for: Style2(configuration: .init()).model) else {
                    fatalError("Can't load Core ML model")
                }
                
                // Create a request to run the model
                let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
                request.imageCropAndScaleOption = .scaleFill

                // Convert the input image to a CIImage
                let ciInputImage = CIImage(image: inputImage)!
                
                // Create a handler to perform the request
                let handler = VNImageRequestHandler(ciImage: ciInputImage)
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
        }
        
        if (modelName == "3") {
            guard let model = try? VNCoreMLModel(for: Style3(configuration: .init()).model) else {
                fatalError("Can't load Core ML model")
            }
            
            // Create a request to run the model
            let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
            request.imageCropAndScaleOption = .scaleFill

            // Convert the input image to a CIImage
            let ciInputImage = CIImage(image: inputImage)!
            
            // Create a handler to perform the request
            let handler = VNImageRequestHandler(ciImage: ciInputImage)
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let results = request.results as? [VNPixelBufferObservation], let outputImageBuffer = results.first?.pixelBuffer {
            DispatchQueue.main.async {
                self.globalImage = UIImage(pixelBuffer: outputImageBuffer)!
//                self.globalImage = UIImage(ciImage: CIImage(cvPixelBuffer: outputImage))
            }
        } else {
            print("Unexpected result type from VNCoreMLRequest")
        }
    }
}

struct TshirtView_Previews: PreviewProvider {
    @Binding var globalImage: UIImage
    static var previews: some View {
        TshirtView(globalImage: UIImage(), colorToImage: UIImage())
    }
}
