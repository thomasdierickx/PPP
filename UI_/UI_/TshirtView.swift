//
//  TshirtView.swift
//  UI_
//
//  Created by Thomas Dierickx on 29/01/2023.
//

import SwiftUI

struct TshirtView: View {
    
    @State var globalImage: UIImage
    
    var vStackView : some View {
        VStack {
            Image(uiImage: self.globalImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50.0)
        }
    }
    
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Image("Background")
            VStack {
                vStackView
                Button("Save to image") {
                    let image = vStackView.snapshot()

                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text("The image has been saved to your photo album"), dismissButton: .default(Text("OK")))
        }
    }
}

struct TshirtView_Previews: PreviewProvider {
    @Binding var globalImage: UIImage
    static var previews: some View {
        TshirtView(globalImage: UIImage())
    }
}
