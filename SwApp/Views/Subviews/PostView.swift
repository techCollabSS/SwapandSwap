//
//  PostView.swift
//  SwApp
//
//  Created by Juan Alvarez on 11/1/21.
//

import SwiftUI

struct PostView: View {
    
    @State var post: PostModel

    var showHeaderAndFooter: Bool =  true
    
    @State var animateLike: Bool = false
    @State var addHeartAnimationToView: Bool = false
    @State var defaultPadding: Bool = true
    
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    // Alerts
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    enum PostActionSheetOption {
        case general
        case reporting
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            //MARK: HEADER
            if showHeaderAndFooter {
                HStack {
                    NavigationLink(
                        destination: LazyView(content: { // NOTE: Lazy View Avoids the repeated loading of an Item.
                            ProfileView(isMyProfile: false, profileUserID: post.userID, profileDisplayName: post.username, posts: PostArrayObject(userID: post.userID))
                        }),
                        label: {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30, alignment: .center)
                                .cornerRadius(15)
                            
                            Text(post.username)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(Color.MyTheme.DarkGreyColor)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        showActionSheet.toggle()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    })
                        .accentColor(Color.MyTheme.DarkGreyColor)
                        .actionSheet(isPresented: $showActionSheet, content: {
                            getActionSheet()
                        })
                }
                .padding()
            }
            
            //MARK: IMAGE
            
            ZStack {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(12)
                    .padding(defaultPadding == true ? 15:0)
                    .onTapGesture(count: 2) {
                        if !post.likedByUser {
                            likePost()
                            AnalyticsService.instance.likePostDoubleTap()
                        }
                    }
                if addHeartAnimationToView {
                    LikeAnimationView(animate: $animateLike)
                }
            }
            
            //MARK: FOOTER
        
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20, content: {
                    
                    // IMPROVEMENT: Research the way to implement this in a function
                    
                    // MARK: SWAP ICON
                    if currentUserID != nil {
                        NavigationLink(
                            destination: ChatSendMessageView(toUserId: post.userID, toUserDisplayName: post.username, swapMessage: post.caption),
                            label: {
                                Image("swap.sflogo")
                                    .font(Font.title2.weight(.semibold))
                                    .foregroundColor(Color.MyTheme.orangeColor)
                            })
                    } else {
                        NavigationLink(
                            destination: SignUpView(),
                            label: {
                                Image("swap.sflogo")
                                    .font(.title2)
                                    .foregroundColor(Color.MyTheme.orangeColor)
                            })
                        }

                    // MARK: Like Button
                    if currentUserID != nil {
                        Button(action: {
                            if post.likedByUser {
                                //unlike
                                unlikePost()
                            } else {
                                //like
                                likePost()
                                AnalyticsService.instance.likePostHeartPressed()
                            }
                        }, label: {
                            Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(post.likedByUser ? .red : Color.MyTheme.DarkGreyColor)
                        })
                            .accentColor(post.likedByUser ? .red : Color.MyTheme.DarkGreyColor)
                        
                    } else {
                        NavigationLink(
                            destination: SignUpView(),
                            label: {
                                Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                            })
                        }
                    
                //MARK: COMMENT ICON
                    if currentUserID != nil {
                        NavigationLink(
                            destination: CommentsView(post: post),
                            label: {
                                Image(systemName: "bubble.middle.bottom")
                                    .font(.title3)
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)

                            })
                    } else {
                        NavigationLink(
                            destination: SignUpView(),
                            label: {
                                Image(systemName: "bubble.middle.bottom")
                                    .font(.title3)
                                    .foregroundColor(Color.MyTheme.DarkGreyColor)
                            })
                        }
                    
                    //MARK: SHARE ICON
//                    Button(action: {
//                        sharePost()
//                    }, label: {
//                        Image(systemName: "paperplane")
//                            .font(.title3)
//                    })
//                    .accentColor(Color.MyTheme.DarkGreyColor)
                    
                    Spacer()
                })
                .padding(.leading, 15)
                .padding(.bottom, 12)
                
                if let caption = post.caption {
                   
                    HStack {
                        Text(caption)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.bottom, 25)
                    .padding(.leading, 15)
                }
            }
        })
            .background(Color.MyTheme.whiteColor)
            .cornerRadius(12)
            .padding(.leading, defaultPadding == true ? 15:7)
            .padding(.trailing, defaultPadding == true ? 15:7)
            .padding(.bottom, defaultPadding == true ? 10:0)
            .onAppear {
                getImages()
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
    
    //MARK: FUNCTIONS
    
     func likePost() {
        guard let userID = currentUserID else {
            print("CANNOT FIND USERID WHILE LIKING POST")
            return
        }
        
        //Update local data (POST MODEL)
         let updatePost = PostModel(postID: post.postID, userID: post.userID, username: post.username, postCategory: post.postCategory, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, likedByUser: true)
        self.post = updatePost // Updated version of post
        // Animte UI
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animateLike = false
        } // deadline: animation duration is 0.5 sec
        
        // Update the database
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
    }
    
    func unlikePost() {
        guard let userID = currentUserID else {
            print("CANNOT FIND USERID WHILE UNLIKING POST")
            return
        }
    
        let updatePost = PostModel(postID: post.postID, userID: post.userID, username: post.username, postCategory: post.postCategory, caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = updatePost // Updated version of post
        
        // Update the database
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
    }
    
    func getImages() {
        
        // Get profile image
        // NOTE: Sames as ProfileView
        ImageManager.instance.downloadProfileImage(userID: post.userID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
        
        // Get post Image
        ImageManager.instance.downloadPostImage(postID: post.postID) { (returnedImage) in
            if let image = returnedImage {
                self.postImage = image
            }
        }
    }
    
    func getActionSheet() -> ActionSheet {
        
        switch self.actionSheetType {
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                .destructive(Text("Report"), action: {
                    
                    self.actionSheetType = .reporting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                }),
                
                    .default(Text("Learn more..."), action: {
                        print("LEARN MORE PRESSED")
                }),
                .cancel()
            ])
        case .reporting:
            return ActionSheet(title: Text("Why are you reporting this post?"), message: nil, buttons: [
            
                .destructive(Text("This is inappropriate"), action: {
                    reportPost(reason: "This is inappropriate")
                }),
            
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam")
                }),
            
                .destructive(Text("It may me uncomfortable"), action: {
                    reportPost(reason: "It may me uncomfortable")
                }),
                .cancel({
                    self.actionSheetType = .general
                })
            ])
        }
    }
    
    func reportPost(reason: String) {
        print("REPORST POST NOW")
        
        DataService.instance.uploadReport(reason: reason, postID: post.postID) { (success) in
            if success {
                self.alertTitle = "Reported!"
                self.alertMessage = "Thanks for reporting this posts. We will review it shortly and take the appropriate action!"
                self.showAlert.toggle()
            } else {
                self.alertTitle =  "Error"
                self.alertMessage = "There was an error uploading the report. Please restart the app and try again."
                self.showAlert.toggle()
            }
        }
        
    }
    
    func sharePost() {
        
        let message = "Check out this post on Swap & Swap!"
        let image = postImage
        let link = URL(string: "https://www.google.com")! //TO DO: Link back to the app LATER. Check questions on video 24
        
        let activityViewController = UIActivityViewController(activityItems: [message, image, link], applicationActivities: nil)
        
        let viewController = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first?.rootViewController
        
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postID: "", userID: "", username: "Joe Green", postCategory: "Test", caption: "This is a test caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true, addHeartAnimationToView: true, defaultPadding: true)
            .previewLayout(.sizeThatFits)
    }
}
