//
//  Segmentator.swift
//  ImagesegmentationTest
//
//  Created by Jonas Gamburg on 06/08/2022.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Vision

struct Segmentator {
    
    //    func runCoreImage(){
    //        let input = CIImage(cgImage: inputImage.cgImage!)
    //        filter.inputImage = CIImage(cgImage: inputImage.cgImage!)
    //
    //        if let maskImage = filter.outputImage{
    //
    //            let ciContext = CIContext(options: nil)
    //
    //            let maskScaleX = input.extent.width / maskImage.extent.width
    //            let maskScaleY = input.extent.height / maskImage.extent.height
    //
    //            let maskScaled =  maskImage.transformed(by: __CGAffineTransformMake(maskScaleX, 0, 0, maskScaleY, 0, 0))
    //
    //            let maskRef = ciContext.createCGImage(maskScaled, from: maskScaled.extent)
    //            self.outputImage = UIImage(cgImage: maskRef!)
    //
    //        }
    //    }
    
    static func runVisionRequest(backgroundImage: UIImage, inputImage: UIImage, outputImage: inout UIImage, finalOutputImage: inout UIImage, isLoading: inout Bool) {
        let request               = VNGeneratePersonSegmentationRequest()
        request.qualityLevel      = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        
        guard let cgImage = inputImage.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([request])
            
            if let results = request.results,
               let mask    = results.first {
                
                let maskBuffer = mask.pixelBuffer
                Segmentator.maskInputImage(maskBuffer,
                                           backgroundImage:  backgroundImage,
                                           inputImage:       inputImage,
                                           outputImage:      &outputImage,
                                           finalOutputImage: &finalOutputImage,
                                           isLoading:        &isLoading)
            }
            
        } catch {
            print(error)
        }
    }

    static func maskInputImage(_ buffer: CVPixelBuffer, backgroundImage: UIImage, inputImage: UIImage, outputImage: inout UIImage, finalOutputImage: inout UIImage, isLoading: inout Bool) {
        let backgroundImage = backgroundImage
        
        guard let inputCgImage      = inputImage.cgImage,
              let backgroundCgImage = backgroundImage.cgImage else { return }
        
        let input      = CIImage(cgImage: inputCgImage)
        let mask       = CIImage(cvPixelBuffer: buffer)
        let background = CIImage(cgImage: backgroundCgImage)
        
        //MARK: Masked CIImage
        let maskScaleX = input.extent.width / mask.extent.width
        let maskScaleY = input.extent.height / mask.extent.height
        let maskScaled = mask.transformed(by: __CGAffineTransformMake(maskScaleX, 0, 0, maskScaleY, 0, 0))
        
        //MARK: Background CIImage
        let backgroundScaleX = input.extent.width / background.extent.width
        let backgroundScaleY = input.extent.height / background.extent.height
        let backgroundScaled = background.transformed(by: __CGAffineTransformMake(backgroundScaleX, 0, 0, backgroundScaleY, 0, 0))
        
        //MARK: Blend filter
        let blendFilter             = CIFilter.blendWithMask()
        blendFilter.inputImage      = input
        blendFilter.backgroundImage = backgroundScaled
        blendFilter.maskImage       = maskScaled
        
        
        guard let blendedImage = blendFilter.outputImage else { return }
        let ciContext = CIContext(options: nil)
        
        guard let maskDisplayRef   = ciContext.createCGImage(maskScaled, from: maskScaled.extent),
              let filteredImageRef = ciContext.createCGImage(blendedImage, from: blendedImage.extent) else { return }
        
        // The 'cutout' from the original image
        outputImage      = .init(cgImage: maskDisplayRef)
        
        // The 'cutout' + the background image blended
        finalOutputImage = .init(cgImage: filteredImageRef)

        isLoading = false
    }
}

