//
//  Firebase.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
import Combine


// MARK: - FirebaseManager Class Firebase API Integration
class FirebaseManager: ObservableObject {
    
    static let shared = FirebaseManager() // Singleton instance
    @Published var galleryItems: [GalleryItem] = []
    @Published var IDdictionary: [String:GalleryItem] = [:]
    
    init() {
        
         // Automatically fetch and download data when ViewModel is initialized
        fetchAndDownloadData()
         
    }
    
    /// Fetches data from Firebase Realtime Database and initiates the parsing process.
    func fetchAndDownloadData() {
        print("Fetching")
        let ref = Database.database().reference() // Adjust this reference to your specific database structure
        var ListItems = [GalleryItem]()
        
        // Fetches the data snapshot once
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            // Ensure the snapshot contains a dictionary
            guard let self = self, let value = snapshot.value as? [String: Any] else { return }
            
            // Parse the fetched JSON data
            
            let dispatchGroup = DispatchGroup() // Use a dispatch group to handle asynchronous image downloading
            
            // Iterate through each key-value pair in the JSON
            for (_, value) in value {
                guard let dict = value as? [String: Any],
                      let ID = dict["id"] as? String,
                      let name = dict["name"] as? String,
                      let address = dict["address"] as? String,
                      let founded = dict["founded"] as? String,
                      let info = dict["info"] as? String,
                      let type = dict["type"] as? String,
                      let pictureURLs = dict["pictures"] as? [String] else { continue }
                
                var pictures: [UIImage] = []
                for url in pictureURLs {
                    dispatchGroup.enter()
                    downloadImage(from: url) { image in
                        if let image = image {
                            pictures.append(image)
                        }
                        dispatchGroup.leave()
                    }
                }
                
                
                dispatchGroup.notify(queue: .main) { // Once all images are downloaded
                    let item = GalleryItem(ID: ID, name: name, address: address, founded: founded, info: info, type: type, images: pictures)
                    ListItems.append(item)
                    self.galleryItems.append(item)
                    self.IDdictionary[ID] = item
                    print("\(name) added")
                }

            }
            
            
        })
        
        
        /// Downloads images from provided URLs and updates the location item.
        func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            // Check if the URL is a Firebase Storage URL
            if urlString.hasPrefix("gs://") {
                // Resolve the Firebase Storage URL to an HTTP URL
                fetchDownloadURL(forPath: urlString) { [weak self] result in
                    switch result {
                    case .success(let url):
                        downloadImageFromURL(url, completion: completion)
                    case .failure(_):
                        completion(nil)
                    }
                }
            } else if let url = URL(string: urlString) {
                // If it's a direct HTTP URL, proceed to download the image
                downloadImageFromURL(url, completion: completion)
            } else {
                // The URL is neither a Firebase Storage URL nor a valid HTTP URL
                completion(nil)
            }
        }
        
        func fetchDownloadURL(forPath path: String, completion: @escaping (Result<URL, Error>) -> Void) {
            let storageRef = Storage.storage().reference(forURL: path)
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
        }
        
        func downloadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
        
        
    }
    
}

// MARK: - GalleryItem Model
struct GalleryItem: Identifiable, Equatable {
    let id = UUID() // Unique identifier for SwiftUI List compatibility
    let ID: String
    let name: String
    let address: String
    let founded: String
    let info: String
    let type: String
    var images: [UIImage] = [] // To store downloaded images
    
    // Equatable protocol conformance to compare LocationItem instances
    static func == (lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - GalleryViewModel
class GalleryViewModel: ObservableObject {
    static let shared = GalleryViewModel()
    @Published var MyItems: [GalleryItem] = []
    
    /*
    func fetchGalleryItems() {
        FirebaseManager.shared.fetchAndDownloadData { [weak self] (ListItem: [GalleryItem]) in
            DispatchQueue.main.async {
                self?.MyItems = ListItem
            }
        }
    }
     */
    
}








/*
 import Foundation
 import Firebase
 import FirebaseStorage
 import Foundation
 import Firebase
 import UIKit // Import UIKit for UIImage
 
 // MARK: - GalleryItem Model
 struct GalleryItem: Identifiable {
 let id = UUID()
 var name: String
 var info: String
 var founded: String
 var fullName: String
 var address: String
 var pictures: [UIImage] // Change from [String] to [UIImage]
 var type: String
 }
 
 // MARK: - GalleryList Struct
 struct GalleryList {
 var sculptures: [GalleryItem] = []
 var buildings: [GalleryItem] = []
 var infrastructures: [GalleryItem] = []
 }
 
 // MARK: - FirebaseManager Class Firebase API Integration
 class FirebaseManager {
 // Your initialization and shared instance remain the same.
 static let shared = FirebaseManager() // Singleton instance
 private init() {}
 
 func fetchCategorizedGalleryItems(completion: @escaping (GalleryList) -> Void) {
 let dbRef = Database.database().reference()
 dbRef.observeSingleEvent(of: .value, with: { snapshot in
 var galleryList = GalleryList()
 
 guard let value = snapshot.value as? [String: [String: Any]] else {
 completion(galleryList)
 return
 }
 
 let dispatchGroup = DispatchGroup() // Use a dispatch group to handle asynchronous image downloading
 
 var count = 1
 for (key, _) in value {
 print(count, key)
 count += 1
 }
 
 if let mydata = value as? [String: [String: Any]] {
 for (name, details) in mydata {
 guard let type = details["type"] as? String,
 let info = details["info"] as? String,
 let founded = details["founded"] as? String,
 let address = details["address"] as? String,
 let fullname = details["name"] as? String,
 let pictureURLs = details["pictures"] as? [String] else { continue }
 
 var pictures: [UIImage] = []
 for url in pictureURLs {
 dispatchGroup.enter()
 self.downloadImage(from: url) { [weak self] image in
 guard let self = self else { return }
 if let image = image {
 pictures.append(image)
 }
 dispatchGroup.leave()
 }
 }
 
 
 dispatchGroup.notify(queue: .main) { // Once all images are downloaded
 let item = GalleryItem(name: name, info: info, founded: founded, fullName: fullname, address: address, pictures: pictures, type: type)
 
 switch type {
 case "Sculpture":
 galleryList.sculptures.append(item)
 case "Building":
 galleryList.buildings.append(item)
 case "Infrastructure":
 galleryList.infrastructures.append(item)
 default: break
 }
 }
 }
 }
 
 dispatchGroup.notify(queue: .main) {
 completion(galleryList) // Complete with the full gallery list once all images are downloaded
 }
 })
 }
 
 private func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
 // Check if the URL is a Firebase Storage URL
 if urlString.hasPrefix("gs://") {
 // Resolve the Firebase Storage URL to an HTTP URL
 fetchDownloadURL(forPath: urlString) { [weak self] result in
 switch result {
 case .success(let url):
 self?.downloadImageFromURL(url, completion: completion)
 case .failure(_):
 completion(nil)
 }
 }
 } else if let url = URL(string: urlString) {
 // If it's a direct HTTP URL, proceed to download the image
 downloadImageFromURL(url, completion: completion)
 } else {
 // The URL is neither a Firebase Storage URL nor a valid HTTP URL
 completion(nil)
 }
 }
 
 private func fetchDownloadURL(forPath path: String, completion: @escaping (Result<URL, Error>) -> Void) {
 let storageRef = Storage.storage().reference(forURL: path)
 storageRef.downloadURL { url, error in
 if let error = error {
 completion(.failure(error))
 } else if let url = url {
 completion(.success(url))
 }
 }
 }
 
 private func downloadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
 URLSession.shared.dataTask(with: url) { data, response, error in
 guard let data = data, error == nil else {
 DispatchQueue.main.async {
 completion(nil)
 }
 return
 }
 let image = UIImage(data: data)
 DispatchQueue.main.async {
 completion(image)
 }
 }.resume()
 }
 
 
 
 }
 
 // MARK: - GalleryViewModel
 class GalleryViewModel: ObservableObject {
 static let shared = GalleryViewModel()
 @Published var sculptures: [GalleryItem] = []
 @Published var buildings: [GalleryItem] = []
 @Published var infrastructures: [GalleryItem] = []
 
 func fetchGalleryItems() {
 FirebaseManager.shared.fetchCategorizedGalleryItems { [weak self] (galleryList: GalleryList) in
 DispatchQueue.main.async {
 self?.sculptures = galleryList.sculptures
 self?.buildings = galleryList.buildings
 self?.infrastructures = galleryList.infrastructures
 }
 }
 }
 
 }
 */
