//
//  ImagePickerView.swift
//  ImagesegmentationTest
//
//  Created by Jonas Gamburg on 06/08/2022.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    
    var source: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var image: UIImage
    @Binding var isPresented: Bool

    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController        = UIImagePickerController()
        pickerController.sourceType = source
        pickerController.delegate   = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }
    
    
}


final class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage
    @Binding var isPresented: Bool
    
    init(image: Binding<UIImage>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}
