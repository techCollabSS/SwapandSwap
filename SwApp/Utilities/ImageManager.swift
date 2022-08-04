//
//  ImageManager.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/25/21.
//

import Foundation
import FirebaseStorage // NOTE: This holds images and videos from user
import SwiftUI

let imageCache = NSCache<AnyObject, UIImage>() // Initialized a blank image cache, and store a bunch of images

class ImageManager {
    
    // MARK: PROPERTIES
    
    static let instance = ImageManager()
    
    private var REF_STOR = Storage.storage() // Entrance to storage
    
    // MARK: PUBLIC FUNCTIONS
    // Functions we call form other places in the app
    
    func uploadProfileImage(userID: String, image: UIImage) {
        
        // Get the path where we will save the image
        let path = getProfileImagePath(userID: userID)
        
        // Save image to path
        DispatchQueue.global(qos: .userInteractive).async { // Multi Threading example NOTE: USE THIS IN HEAVY PROCESSES TO ALLOW THE APP TO RUN SMOOTHER
            self.uploadImage(path: path, image: image) { (_) in }

        }
        // Deleted Cached Image -- Mostly used for when uploading a new profile picture
        imageCache.removeObject(forKey: path)

    }
    
    func uploadPostImage (postID: String, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        // Get the path where we will save the image
        let path = getPostImagePath(postID: postID)
        
        // Save Image to Path
        DispatchQueue.global(qos: .userInteractive).async { // Multi Threading example NOTE: USE THIS IN HEAVY PROCESSES TO ALLOW THE APP TO RUN SMOOTHER
            self.uploadImage(path: path, image: image) { (success) in
                DispatchQueue.main.async {
                    handler(success) // Mutlti Thread If updating the main front end of the app we need to bring it back to the main thread. Handler is what controls weather we are updating or not.
                }
            }
        }
    }
    
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        // Get path where the image is saved
        let path = getProfileImagePath(userID: userID)
        
        // Download image from the path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)

                }
            }
        }
    }
    
    func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // Get the path where the image is saved
        let path = getPostImagePath(postID: postID)
        
        // Download the image from path
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { (returnedImage) in
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    // Functions we call from this file only
    
    private func getProfileImagePath(userID: String) -> StorageReference {
        
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    private func getPostImagePath(postID: String) -> StorageReference {
        
        let postPath = "posts/\(postID)/1" // NOTE: Edit this code to allow multiple images to be uploaded
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath


    }
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        var compression: CGFloat = 1.0 // Loops down by 0.05
        let maxFileSize: Int = 240 * 240 // Maximum file size that we want to save
        let maxCompression: CGFloat = 0.05 // Maximum compression we ever allow
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // Check maximum file size
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05 // reduces the compression by 5%
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }
        
        
        // Get image data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // Get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg" // NOTE: Comeback to fix it for more image file types
        
        // Save data to path
        path.putData(finalData, metadata: metadata) { _, error in
            
            if let error = error {
                //Error
                print("Error uploading image \(error)")
                handler(false)
                return
            } else {
                //Success
                print("Success uploading image")
                handler(true)
                return
            }
        }
        
    }
    
    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: path) {
            print("IMAGE FOUND IN CACHE")
            handler(cachedImage)
            return
            
        } else {
            
            path.getData(maxSize: 27 * 1024 * 1024) { (returnedImageData, error) in
                
                if let data = returnedImageData, let image = UIImage(data: data) {
                    // Success getting image data
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    print("ERROR GETTING DATA FROM PATH FOR IMAGE")
                    handler(nil)
                    return
                }
            }
        }
    }
}

