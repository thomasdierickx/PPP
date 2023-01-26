//
//  RemoveBG.swift
//  UI_
//
//  Created by Thomas Dierickx on 25/01/2023.
//

import SwiftUI
import CoreML
import CoreMedia
import Vision

struct RemoveBG: View {

    @State var inputImage: [UIImage]
    
    @State var outputImage: [UIImage]
    
    @State var isShown = false
    
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
                HStack {
                    VStack {
                        ForEach(inputImage.indices, id: \.self) { index in
                            Image(uiImage: self.inputImage[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100.0)
                        }
                    }
                    VStack {
                        ForEach(outputImage.indices, id: \.self) { index in
                            Image(uiImage: self.outputImage[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100.0)
                        }
                    }
                }
                if !isShown {
                    Button(action: {runVisionRequest()}, label: {
                        Text("Run Image Segmentation")
                    })
                    .padding()
                } else {
                    NavigationLink(destination: {}) {
                        Button(action: {}) {
                            Text("NEXT")
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
    }
    
    func runVisionRequest() {

        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model)
        else { return }

        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill

        for i in 0..<inputImage.count {
            DispatchQueue.global().async {

                let handler = VNImageRequestHandler(cgImage: inputImage[i].cgImage!, options: [:])
                
                do {
                    try handler.perform([request])
                }catch {
                    print(error)
                }
                
                print(inputImage[0])
                print(outputImage[0])
            }
        }
    }
    
    func maskInputImage() {
        for i in 0..<inputImage.count {
            let bgImage = UIImage.imageFromColor(color: UIColor(Color.black.opacity(0.0)), size: CGSize(width: self.inputImage[i].size.width, height: self.inputImage[i].size.height), scale: self.inputImage[i].scale)!
            
            let beginImage = CIImage(cgImage: inputImage[i].cgImage!)
            let background = CIImage(cgImage: bgImage.cgImage!)
            let mask = CIImage(cgImage: outputImage[i].cgImage!)
            
            print(inputImage[i])
            print(outputImage[i])
            
            if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
                                            kCIInputImageKey: beginImage,
                                            kCIInputBackgroundImageKey:background,
                                            kCIInputMaskImageKey:mask])?.outputImage
            {
                let ciContext = CIContext(options: nil)

                let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
                
                inputImage[i] = UIImage(cgImage: filteredImageRef!)
            }
        }
        isShown = true
    }


    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        for i in 0..<inputImage.count {
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation], let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 5)
                    
                    self.outputImage[i] = segmentationMask!.resizedImage(for: self.inputImage[i].size)!
                    
                    maskInputImage()
                }
            }
        }
    }
}

struct GradientPoint {
   var location: CGFloat
   var color: UIColor
}

struct RemoveBG_Previews: PreviewProvider {
    @Binding var inputImage: [UIImage]
    static var previews: some View {
        RemoveBG(inputImage: [], outputImage: [])
    }
}
