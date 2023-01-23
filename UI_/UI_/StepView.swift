//
//  StepView.swift
//  UI_
//
//  Created by Thomas Dierickx on 23/01/2023.
//

import SwiftUI

struct StepView: View {
    var body: some View {
            ZStack {
                Image("Background")
                VStack {
                    Text("Make your own")
                        .font(.system(size: 25) .weight(.bold))
                        .font(.custom("NunitoSans", size: 25))
                        .foregroundColor(Color("DarkBlue"))
                    Text("T-SHIRT")
                        .font(.system(size: 86) .weight(.heavy))
                        .foregroundColor(Color("DarkBlue"))
                    VStack {
                        Text("Step1.")
                            .font(.system(size: 20) .weight(.bold))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                        Text("Choose 3 to 5 different images from your gallery")
                            .font(.system(size: 20) .weight(.regular))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                    }
                    .padding()
                    VStack {
                        Text("Step2.")
                            .font(.system(size: 20) .weight(.bold))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                        Text("The program will automatically give you a generated image based on the images you sent in.")
                            .font(.system(size: 20) .weight(.regular))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                    }
                    .padding()
                    VStack {
                        Text("Step3.")
                            .font(.system(size: 20) .weight(.bold))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                        Text("Once step 2 is done, you can \n- Reset the process again \n- Change the style \n- Look at the end result")
                            .font(.system(size: 20) .weight(.regular))
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(Color("DarkBlue"))
                            .frame(maxWidth: 300, alignment: .leading)
                    }
                    .padding()
                    NavigationLink(destination: ChooseImgs()) {
                        Button(action: { }) {
                            Text("BEGIN")
                                .font(.system(size: 20) .weight(.bold))
                                .foregroundColor(Color("White"))
                        }
                        .frame(maxWidth: 300, maxHeight: 50)
                        .background(Color("LightBlue"))
                        .cornerRadius(30)
                    }
                    .padding()
                    .padding()
                }
            }
    }
}

struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView()
    }
}
