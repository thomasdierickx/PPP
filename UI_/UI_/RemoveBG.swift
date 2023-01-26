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

    @Binding var inputImage: [UIImage]
    @Binding var outputImage: [UIImage]
    
    @State var newArr: [UIImage]
    
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
                                .frame(width: 50.0)
                        }
                    }
                    VStack {
                        ForEach(outputImage.indices, id: \.self) { index in
                            Image(uiImage: self.outputImage[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.0)
                        }
                    }
                }
                Button(action: {runVisionRequest()}, label: {
                    Text("Run Image Segmentation")
                })
                .padding()
            }
        }
    }
    
    func runVisionRequest() {

        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model)
        else { return }

        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill

        for input in inputImage {
            DispatchQueue.global().async {

                let handler = VNImageRequestHandler(cgImage: input.cgImage!, options: [:])
                
                do {
                    try handler.perform([request])
                }catch {
                    print(error)
                }
            }
        }
    }
    
    func maskInputImage() {
        let bgImage = UIImage.imageFromColor(color: UIColor(Color.white.opacity(0.0)), size: CGSize(width: self.inputImage[0].size.width, height: self.inputImage[0].size.height), scale: self.inputImage[0].scale)!

        for i in 0..<inputImage.count {
            let beginImage = CIImage(cgImage: inputImage[i].cgImage!)
            let background = CIImage(cgImage: bgImage.cgImage!)
            let mask = CIImage(cgImage: outputImage[i].cgImage!)
            
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
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        for i in 0..<inputImage.count {
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation], let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    
                    self.outputImage[i] = segmentationMask!.resized(to: self.inputImage[i].size)
                    
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
        RemoveBG(inputImage: .constant([]), outputImage: .constant([]), newArr: [])
    }
}
