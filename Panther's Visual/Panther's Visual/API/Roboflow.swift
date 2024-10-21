//
//  Roboflow.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import Foundation
import UIKit

var Class: String = ""
var Confidence: String = ""
var EmptyItem = GalleryItem(ID: "", name: "No results", address: "", founded: "", info: "", type: "", images: [])

class RoboflowService {
    
    func CheckMatch(){
        
    }
    
    
    func performRequest(with base64String: String, completion: @escaping (String, String) -> Void) {
        
        
        // Load Image and Convert to Base64
        let image = UIImage(named: "YOUR_IMAGE.jpg")
        let imageData = image?.jpegData(compressionQuality: 1)
        _ = imageData?.base64EncodedString()
        let bodyString = "data:image/jpeg;base64,\(base64String)"
        let postData = bodyString.data(using: .utf8)
        
        // Initialize Inference Server Request with API_KEY, Model, and Model Version
        var request = URLRequest(url: URL(string: "https://detect.roboflow.com/panther-visual/4?api_key=Ed2vQBx4iYVSpTwspSFI&name=YOUR_IMAGE.jpg")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // Execute Post Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response here
            guard let data = data, error == nil else {
                print(String(describing: error))
                completion("Error", "0") // Error handling
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let predictions = jsonResponse["predictions"] as? [[String: Any]],
                   let firstPrediction = predictions.first,
                   let predictionClass = firstPrediction["class"] as? String,
                   let confidence = firstPrediction["confidence"] as? Double {
                                        
                    let formattedConfidence = String(format: "%.2f%%", confidence * 100)
                    DispatchQueue.main.async {
                        completion(predictionClass, formattedConfidence)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("No results", "0") // No results found
                        print(completion)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion("Error", "0") // JSON parsing error
                }
            }
        
        }.resume()
    }
}
