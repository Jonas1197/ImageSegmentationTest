//
//  GrowingButton.swift
//  ImagesegmentationTest
//
//  Created by Jonas Gamburg on 08/08/2022.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
