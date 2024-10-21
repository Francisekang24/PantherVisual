//
//  ImagePicker.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI
import UIKit


private let service = RoboflowService()

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?
    @Binding var classID: String?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                
                // Convert UIImage to JPEG Data
                guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
                        
                // Convert Data to Base64 Encoded String
                let base64String = imageData.base64EncodedString()
                        
                // Perform the API request with the base64 image string
                service.performRequest(with: base64String) { resultClass, resultConfidence in
                            // Update the results
                    self.parent.classID = resultClass
                        }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
