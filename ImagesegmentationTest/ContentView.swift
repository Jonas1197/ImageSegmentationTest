//
//  ContentView.swift
//  ImagesegmentationTest
//
//  Created by Jonas Gamburg on 06/08/2022.
//

import SwiftUI


struct ContentView: View {
    
    @State private var finalOutputImage: UIImage = .init(named: "background")!
    @State private var outputImage:      UIImage = .init(named: "background")!
    @State private var inputimage:       UIImage = .init(named: "sample")!
    
    @State private var selectedBackgroundImage: UIImage = .init(named: "background")!
    
    @State private var isInputPicutrePicturePickerPresented      = false
    @State private var isBackgroundPicutrePicturePickerPresented = false
    @State private var loading                                   = true
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Image(uiImage: inputimage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
      
                Image(uiImage: outputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Image(uiImage: finalOutputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                    .frame(height: 32)
                
                HStack(alignment: .center, spacing: 30) {
                    Button("Input image") {
                        isInputPicutrePicturePickerPresented = true
                    }
                    .buttonStyle(GrowingButton())
                    
                    Button("Background image") {
                        isBackgroundPicutrePicturePickerPresented = true
                    }
                    .buttonStyle(GrowingButton())
                }
                
                Spacer()
                    .frame(height: 32)
            }
            
            LoadingView()
                .opacity(loading ? 1 : 0)
                .animation(.easeInOut(duration: 0.4), value: 0)
        
            
        }.task {
            Segmentator.runVisionRequest(backgroundImage: selectedBackgroundImage,
                                         inputImage: inputimage,
                                         outputImage: &outputImage,
                                         finalOutputImage: &finalOutputImage,
                                         isLoading: &loading)
        }
        .sheet(isPresented: $isInputPicutrePicturePickerPresented) {
            ImagePickerView(source: .photoLibrary, image: $inputimage, isPresented: $isInputPicutrePicturePickerPresented)
        }
        .sheet(isPresented: $isBackgroundPicutrePicturePickerPresented) {
            ImagePickerView(source: .photoLibrary, image: $selectedBackgroundImage, isPresented: $isBackgroundPicutrePicturePickerPresented)
        }
        .onChange(of: inputimage) { newValue in
            loading = true
            Segmentator.runVisionRequest(backgroundImage: selectedBackgroundImage,
                                         inputImage: inputimage,
                                         outputImage: &outputImage,
                                         finalOutputImage: &finalOutputImage,
                                         isLoading: &loading)
        }
        .onChange(of: selectedBackgroundImage) { newValue in
            loading = true
            Segmentator.runVisionRequest(backgroundImage: selectedBackgroundImage,
                                         inputImage: inputimage,
                                         outputImage: &outputImage,
                                         finalOutputImage: &finalOutputImage,
                                         isLoading: &loading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
