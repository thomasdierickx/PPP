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
    
    var hStack2 : some View {
        HStack {
                HStack {
                    ForEach(resultImage.indices, id: \.self) { index in
                        Image(uiImage: self.resultImage[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                    }
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
                    Button(action: {runVisionRequest()}, label: {
                        Text("Run Image Segmentation")
                    })
                    .padding()
                    if loadingBar {
                        ActivityIndicator(isAnimating: $loadingBar, style: .large)
                    }
                } else {
                    hStack2
                    NavigationLink(destination: ResultImg(inputImage: self.inputImage)) {
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
        loadingBar = true
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }
        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill
        
        DispatchQueue.global().async {
            for i in 0..<inputImage.count {
                let handler = VNImageRequestHandler(cgImage: inputImage[i].cgImage!, options: [:])
                do {
                    try handler.perform([request])
                }catch {
                    print(error)
                }
            }
        }
    }
    
    func maskInputImage() {
        print("maskInputImage: input \(inputImage.count), output \(outputImage.count)")
        let bgImage = UIImage.imageFromColor(color: UIColor(Color.black.opacity(0.0)), size: CGSize(width: inputImage[0].size.width, height: inputImage[0].size.height), scale: inputImage[0].scale)!
            
        var divider = 0
        
        if inputImage.count > 0 {
            divider = 1
        }
        
        if inputImage.count > 1 {
            divider = 2
        }
        
        if inputImage.count > 3 {
            divider = 4
        }
        
        if inputImage.count > 4 {
            divider = 5
        }
        
        for i in 0..<inputImage.count/divider{
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
//                outputImage.append(UIImage(cgImage: filteredImageRef!))
            }
        }
        isShown = true
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        print("visionRequestDidComplete")
            DispatchQueue.main.async {
                if let observations = request.results as? [VNCoreMLFeatureValueObservation], let segmentationmap = observations.first?.featureValue.multiArrayValue {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    
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
