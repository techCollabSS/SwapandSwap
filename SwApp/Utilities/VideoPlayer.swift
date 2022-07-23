//
//  VideoPlayer.swift
//  SwApp
//
//  Created by Juan Alvarez on 7/22/22.
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayer: View {
    var body: some View {
           VideoPlayerController()
       }
   }

   struct VideoPlayer_Previews: PreviewProvider {
       static var previews: some View {
           VideoPlayer()
       }
   }

   final class VideoPlayerController : UIViewControllerRepresentable {
       var playerLooper: AVPlayerLooper?
       
       func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayerController>) ->
           AVPlayerViewController {
               let controller = AVPlayerViewController()
               controller.showsPlaybackControls = false
               
               guard let path = Bundle.main.path(forResource: "onboarding", ofType:"mp4") else {
                   debugPrint("onboarding video not found")
                   return controller
               }
                       
               let asset = AVAsset(url: URL(fileURLWithPath: path))
               let playerItem = AVPlayerItem(asset: asset)
               let queuePlayer = AVQueuePlayer()
               // OR let queuePlayer = AVQueuePlayer(items: [playerItem]) to pass in items
               
               playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
               queuePlayer.play()
               controller.player = queuePlayer
                   
               return controller
           }
       
       func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayerController>) {
       }
   }
