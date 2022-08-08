//
//  LoadingView.swift
//  ImagesegmentationTest
//
//  Created by Jonas Gamburg on 06/08/2022.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.8)
            
            VStack {
                ProgressView()
                Text("Processing...")
                    .foregroundColor(.white)
            }
        }
    }
}
