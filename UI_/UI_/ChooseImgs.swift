//
//  ChooseImgs.swift
//  UI_
//
//  Created by Thomas Dierickx on 23/01/2023.
//

import SwiftUI
import UIKit
import PhotosUI

struct ChooseImgs: View {
    
    @State private var showAlert = false
    
    @State private var image: Image?
    @State private var showingImagePicker = true
    @State private var inputImage = [UIImage]()
    
    @State private var imgMin = 2
    @State private var imgMax = 4
    
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
                    HStack {
                        ForEach(inputImage, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.0)
                                .onTapGesture {
                                    self.showAlert = true
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Delete"),
                                        message: Text("You are deleting an image, do you want to continue?"),
                                        primaryButton: .default(Text("Yes")) {
                                            if let index = self.inputImage.firstIndex(of: img) {
                                                self.inputImage.remove(at: index)
                                            }},
                                        secondaryButton: .default(Text("No")))
                                }
                        }
                    }
                    Text("(Choose min. of 3 to a max. 5 images)")
                    Text("(Tap on the image to delete it)")
                        .font(.system(size: 15) .weight(.light))
                        .foregroundColor(Color("DarkBlue"))
                    if inputImage.count < imgMax {
                        NavigationLink(destination: ImagePicker(image: self.$inputImage)) {
                            Button(action: {
                                self.showingImagePicker = true
                            }) {
                                Text("Choose different images")
                                    .font(.system(size: 20) .weight(.bold))
                                    .foregroundColor(Color("White"))
                            }
                            .frame(maxWidth: 300, maxHeight: 50)
                            .background(Color("LightBlue"))
                            .cornerRadius(30)
                        }
                        .padding()
                    }
                    if inputImage.count > imgMin {
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
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: self.$inputImage)
            }
    }
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = context.coordinator
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
                parent.image.append(uiImage)
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
