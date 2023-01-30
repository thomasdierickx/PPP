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
            VStack {
                ForEach(inputImage.indices, id: \.self) { index in
                    Image(uiImage: self.inputImage[index])
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
                    hStack
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
        
        for i in 0..<inputImage.count {
            let handler = VNImageRequestHandler(cgImage: inputImage[i].cgImage!, options: [:])
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                }catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loadingBar = false
        }
    }
    
    func maskInputImage() {
        
        var bgImage: UIImage
        var beginImage: CIImage
        var background: CIImage
        var mask: CIImage
        
        for i in 0..<inputImage.count {
            bgImage = UIImage.imageFromColor(color: UIColor(Color.black.opacity(0.0)), size: CGSize(width: self.inputImage[i].size.width, height: self.inputImage[i].size.height), scale: self.inputImage[i].scale)!

            beginImage = CIImage(cgImage: inputImage[i].cgImage!)
            background = CIImage(cgImage: bgImage.cgImage!)
            mask = CIImage(cgImage: outputImage[i].cgImage!)

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
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)
                    
                    self.outputImage[i] = segmentationMask!.resizedImage(for: self.inputImage[i].size)!
                    
                    // check for person
                    let request = VNDetectHumanRectanglesRequest { (request, error) in
                        if let observations = request.results as? [VNDetectedObjectObservation], !observations.isEmpty {
                            // person detected
                            self.maskInputImage()
                            print("Img #\(inputImage[i]): Person is detected")
                        } else {
                            // person not detected
                            print("Img #\(inputImage[i]): Person is not detected")
                        }
                    }
                    // Perform the request
                    let handler = VNImageRequestHandler(cgImage: self.inputImage[i].cgImage!, options: [:])
                    try? handler.perform([request])
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
