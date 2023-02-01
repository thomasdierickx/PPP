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
    @State private var selectedIndex: Int? = nil
    
    @State private var image: Image?
    @State private var showingImagePicker = true
    @State private var inputImage = [UIImage]()
    
    @State private var imgMin = 1
    @State private var imgMax = 5
    
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
                        ForEach(inputImage.indices, id: \.self) { index in
                            Image(uiImage: self.inputImage[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.0)
                                .onTapGesture {
                                    self.selectedIndex = index
                                    self.showAlert = true
                                }
                                .alert(isPresented: self.$showAlert) {
                                    Alert(
                                        title: Text("Delete"),
                                        message: Text(self.inputImage[index].description),
                                        primaryButton: .default(Text("Yes")) {
                                            self.inputImage.remove(at: self.selectedIndex!)
                                        },
                                        secondaryButton: .default(Text("No")))
                                }
                        }
                    }
                    .padding()
                    Text("(Choose min. of \(imgMin) to a max. \(imgMax) images)")
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
                                    .foregroundColor(Color("LightBlue"))
                            }
                            .frame(maxWidth: 300, maxHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("LightBlue"), lineWidth: 3)
                            )
                        }
                        .padding()
                    }
                    if inputImage.count >= imgMin {
                        NavigationLink(destination: RemoveBG(inputImage: self.inputImage, outputImage: self.inputImage)) {
                            Button(action: {}) {
                                HStack {
                                    Text("TO STEP 2")
                                        .font(.system(size: 20) .weight(.bold))
                                        .foregroundColor(Color("White"))
                                    Image("arrow")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .frame(width: 300, height: 50)
                            .background(Color("LightBlue"))
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                    if inputImage.count == 1 {
                        Text("You already have \(inputImage.count) image")
                            .foregroundColor(Color("LightBlue"))
                    } else {
                        Text("You already have \(inputImage.count) images")
                            .foregroundColor(Color("LightBlue"))
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: self.$inputImage)
            }
    }
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
