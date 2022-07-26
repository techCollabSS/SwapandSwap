//
//  CommentsView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/2/21.
//

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    
    var post: PostModel // Var because post is always going to be the same, we are not changing whats in the post
    
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserId: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
    var body: some View {
        VStack {
            
            //Messages Scroll View
            ScrollView {
                LazyVStack {
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            // Bottom HStack
            HStack {
                
                Image(uiImage:  profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                Button(action: {
                    if textIsAppropriate(){
                        addComment()
                    }
                    
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                    
                })
                    .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            }
            .padding(.all, 6)
            
        }
        .padding(.horizontal)
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getComments()
            getProfilePicture()
            
        })
    }
    //MARK: FUNCTIONS
    
    func getProfilePicture()    {
        
        guard let userID = currentUserId else {return}
        
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            
            }
        
        }
    }
    
    func getComments() {
        
        guard self.commentArray.isEmpty else {return}
        print("GET COMMENTS FROM DATABASE")
        
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userID: post.userID, username: post.username, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innapropriate things
       
        // Check for bad words
        let badWordArray: [String] = ["shit", "ass", "fuck"]
        
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        // Check for minimum character count
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func addComment() {
        
        guard let userID = currentUserId, let displayName = currentDisplayName else {return}
        
        DataService.instance.uploadComment(postID: post.postID, content: submissionText, displayName: displayName, userID: userID) {(success, returnedCommentID) in
            if success, let commentID = returnedCommentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Takes the keyboard out after comment submission
            }
        }
        
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postID: "test", userID: "test", username: "test", dateCreated: Date(), likeCount: 0, likedByUser: false)
    static var previews: some View {
        NavigationView {
            CommentsView(post: post)
        }
        .preferredColorScheme(.dark)
    }
}
