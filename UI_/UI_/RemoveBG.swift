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
    @State private var loadingBar = false
    @State var resultImage = [UIImage]()
    
    struct ActivityIndicator: UIViewRepresentable {
        @Binding var isAnimating: Bool
        let style: UIActivityIndicatorView.Style

        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            return UIActivityIndicatorView(style: style)
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        }
    }
    
    var hStack : some View {
        HStack {
            HStack {
                ForEach(inputImage.indices, id: \.self) { index in
                    Image(uiImage: self.inputImage[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                }
            }
        }
    }
    
    var hStack2: some View {
        HStack {
            ForEach(resultImage.indices, id: \.self) { index in
                Image(uiImage: self.resultImage[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75)
            }
        }
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
                if !isShown {
                    hStack
                    Button(action: {runVisionRequest()}) {
                        Text("Run image segmentation")
                            .font(.system(size: 20) .weight(.bold))
                            .foregroundColor(Color("LightBlue"))
                    }
                    .frame(maxWidth: 300, maxHeight: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("LightBlue"), lineWidth: 3)
                    )
                    .padding()
                    if loadingBar {
                        ActivityIndicator(isAnimating: $loadingBar, style: .large)
                    }
                } else {
                    hStack2
                    NavigationLink(destination: ResultImg(inputImage: self.resultImage)) {
                        Button(action: {}) {
                            HStack {
                                Text("TO STEP 3")
                                    .font(.system(size: 20) .weight(.bold))
                                    .foregroundColor(Color("White"))
                                Image("arrow")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .frame(maxWidth: 300, maxHeight: 50)
                        .background(Color("LightBlue"))
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func runVisionRequest() {
        loadingBar = true
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }
        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill
        
        DispatchQueue.global().async {
            for image in inputImage {
              let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
              do {
                try handler.perform([request])
              } catch {
                print(error)
              }
            }
        }
    }
    
    func maskInputImage() {
        print("maskInputImage: input \(inputImage.count), output \(outputImage.count)")

        for i in 0..<inputImage.count{
        
            let bgImage = UIImage.imageFromColor(color: UIColor(Color.black.opacity(0.0)), size: CGSize(width: inputImage[i].size.width, height: inputImage[i].size.height), scale: inputImage[i].scale)!
        
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
                resultImage.append(UIImage(cgImage: filteredImageRef!))
            }
        }
        DispatchQueue.global().async {
            if resultImage.count == 4 {
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
            }
            
            if resultImage.count == 9 {
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 2)
                resultImage.remove(at: 3)
            }
            
            if resultImage.count == 14 {
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 2)
                resultImage.remove(at: 2)
                resultImage.remove(at: 3)
                resultImage.remove(at: 3)
                resultImage.remove(at: 4)
                resultImage.remove(at: 4)
            }
            
            if resultImage.count == 25 {
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 1)
                resultImage.remove(at: 2)
                resultImage.remove(at: 2)
                resultImage.remove(at: 3)
                resultImage.remove(at: 3)
                resultImage.remove(at: 3)
                resultImage.remove(at: 4)
                resultImage.remove(at: 4)
                resultImage.remove(at: 4)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
                resultImage.remove(at: 5)
            }
        }
        isShown = true
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        print("visionRequestDidComplete")
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation], let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 2)
                    
                    for i in 0..<inputImage.count {
                        self.outputImage[i] = segmentationMask!.resizedImage(for: self.inputImage[i].size)!
                    }
                    self.maskInputImage()
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
