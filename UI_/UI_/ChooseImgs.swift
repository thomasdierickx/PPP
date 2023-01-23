//
//  ChooseImgs.swift
//  UI_
//
//  Created by Thomas Dierickx on 23/01/2023.
//

import SwiftUI
import UIKit

struct ChooseImgs: View {
    @State private var image: Image?
    @State private var image2: Image?
    @State private var image3: Image?
    @State private var image4: Image?
    @State private var image5: Image?
    
    @State private var showingImagePicker = true
    @State private var inputImage: UIImage?
    @State private var inputImage2: UIImage?
    @State private var inputImage3: UIImage?
    @State private var inputImage4: UIImage?
    @State private var inputImage5: UIImage?
    
    var uiImageOne: UIImage?
    var uiImageTwo: UIImage?
    var uiImageThree: UIImage?
    
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
                    if !(inputImage == nil) {
                        Image(uiImage: self.inputImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300.0,height: 300.0)
                    }
                    NavigationLink(destination: ImagePicker(image: self.$inputImage)) {
                        Button(action: {
                            self.showingImagePicker = true
                        }) {
                            Text("Choose images")
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
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = context.coordinator
//        picker.allowsMultipleSelection = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ChooseImgs_Previews: PreviewProvider {
    static var previews: some View {
        ChooseImgs()
    }
}
