//
//  DataService.swift
//  SwApp
//
//  Created by Juan Alvarez on 12/1/21.
//

// Used to handle upload and download data (other than user) from our Databaase
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    // MARK: PROPERTIES
    
    static let instance = DataService()
    
    private var REF_POSTS = DB_BASE.collection("posts")
    private var REF_REPORTS = DB_BASE.collection("reports")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    
    // MARK: CREATE FUNCTION
    
    func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // Create new post document in database
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        // Upload image to Storage
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { (success) in
            if success {
                // Successfully uploaded image data to Storage
                // Now upload post data to Database
                
                let postData: [String:Any] = [ // This info comes fromt he Enumes & Structs files
                    
                    DatabasePostField.postID : postID,
                    DatabasePostField.userID : userID,
                    DatabasePostField.displayName : displayName,
                    DatabasePostField.caption : caption!,
                    DatabasePostField.dateCreated : FieldValue.serverTimestamp(),
                ]
                
                document.setData(postData) {(error) in
                    if let error =  error {
                        print("ERROR UPLOADING DATA TO POST DOCUMENT. \(error)")
                        handler(false)
                        return
                        
                    } else {
                        // Return back to the app
                        handler(true)
                        return
                    }
                }
                
            } else {
                print("ERROR UPLOADING POST IMAGE TO FIREBASE")
                handler(false)
                return
            }
        }
    }
    
    func uploadReport(reason: String, postID: String, handler: @escaping (_ success: Bool)-> ()) {
        
        let data: [String:Any] = [
            DatabaseReportField.content: reason,
            DatabaseReportField.postID: postID,
            DatabaseReportField.dateCreated: FieldValue.serverTimestamp(),
        ]
        
        REF_REPORTS.addDocument(data: data) { (error) in
            if let error = error {
                print("ERROR UPLOADING REPORT.\(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    
    func uploadComment(postID: String, content: String, displayName: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> ()) {
        
        let document = REF_POSTS.document(postID).collection(DatabasePostField.comments).document()
        let commentID = document.documentID
        
        let data: [String:Any] = [
        
            DatabaseCommentsField.commentID : commentID,
            DatabaseCommentsField.userID : userID,
            DatabaseCommentsField.content : content,
            DatabaseCommentsField.displayName : displayName,
            DatabaseCommentsField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        document.setData(data) { (error) in
            if let error = error {
                print("ERROR UPLOADING COMMENT. \(error)")
                handler(false, nil)
                return
            } else {
                handler(true, commentID)
                return
            }
        }
    }
    
    // MARK: GET FUNCTIONS
    
    func downloadPostForUser(userID: String, handler: @escaping (_ posts: [PostModel]) -> ()) {
        
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments {(querySnapshot, error) in // NOTE: This will get us all the posts in the posts collections where userID is equal to the userID we are looking for.
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
            
        }
    }
    
    func downloadPostsForFeed(handler: @escaping(_ posts: [PostModel]) -> ()) { //NOTE: This will get the 50 most recent posts in the database, regardless of wether is following someone or not. We got to figure out the following part.
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments { (querySnapshot, error) in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] { // We don't need an escaping handler because at this point we already back in the back and have all the data to run immediately
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents { // NOTE: This will loop through evey document in the snapshot, try to create a new post and append to the array
                
                if
                    let userID = document.get(DatabasePostField.userID) as? String,
                    let displayName = document.get(DatabasePostField.displayName) as? String,
                    let timestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date =  timestamp.dateValue()
                    let postID = document.documentID
                    
                    let  likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0 // Try to get the like count, if there isn't then be 0
                    
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userID = currentUserID {
                        likedByUser = userIDArray.contains(userID)
                    }
                    
                    let newPost = PostModel(postID: postID, userID: userID, username: displayName, caption: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                    postArray.append(newPost)
                }
            }
            return postArray
            
        } else {
            print("NO DOCUMENTS IN SNAPSHOT FOUND FOR THIS USER")
            return postArray
        }
    }
    
    func downloadComments(postID: String, handler: @escaping (_ comments: [CommentModel]) -> ()){
        
        REF_POSTS.document(postID).collection(DatabasePostField.comments).order(by: DatabaseCommentsField.dateCreated, descending: false).getDocuments {
            (querySnapshot, error) in
            handler(self.getCommentsFromSnapshot(querySnapshot: querySnapshot))
        }
        
    }
    
    private func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if
                    let userID = document.get(DatabaseCommentsField.userID) as? String,
                    let displayName = document.get(DatabaseCommentsField.displayName) as? String,
                    let content = document.get(DatabaseCommentsField.content) as? String,
                    let timestamp = document.get(DatabaseCommentsField.dateCreated) as? Timestamp {
                    
                    let date = timestamp.dateValue()
                    let commentID = document.documentID
                    let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: content, dateCreated: date)
                    commentArray.append(newComment) // If new comment exist then append.
                }
            }
            return commentArray
        } else {
            print("NO COMMENTS IN DOCUMENT FOR THIS POST")
            return commentArray
        }
    }
    
    // MARK: UPDATE FUNCTIONS
    
    func likePost(postID: String, currentUserID: String) { // No handler here because is just going to the Database and not coming back
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = 1
        let data: [String: Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) { // No handler here because is just going to the Database and not coming back
        // Update the post count
        // Update the array of users who liked the post
        
        let increment: Int64 = -1
        let data: [String: Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func updateDisplayNameOnPosts(userID: String, displayName: String) {
        
        downloadPostForUser(userID: userID) { (returnedPosts) in
            for post in returnedPosts {
                self.updatePostDisplayName(postID: post.postID, displayName: displayName)
            }
        }
    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        let data: [String:Any] = [
            DatabasePostField.displayName : displayName
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
}
