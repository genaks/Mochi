//
//  PostTableViewCell.swift
//  Mochi
//
//  Created by Akshay Jain on 11/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit
import AVKit
import JGProgressHUD

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoContainerView: UIView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var videoURL : URL?
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var errorView: UIView!

    var postItem : Post!
    
    var HUD : JGProgressHUD!
    
    private var playerItemContext = 0
    
    var active = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.borderWidth = 2.0
        userImageView.layer.borderColor = UIColor.white.cgColor
        
        HUD = JGProgressHUD(style: .dark)
        HUD.textLabel.text = ""
        
        setUpPlayerLayer()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleLike(_:)))
        likesView.addGestureRecognizer(tap)
    }
    
    func setUpPlayerLayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 5
        avPlayer?.actionAtItemEnd = .none
        
        avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: self.videoContainerView.frame.width,
                                           height: self.videoContainerView.frame.size.height)
        self.videoContainerView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemReachedEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
        
    }
    
    func configureCellForPost(post : Post) {
        postItem = post
        videoPlayerItem = AVPlayerItem.init(url : post.video_url)
        self.videoPlayerItem!.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        usernameLabel.text = post.user!.username;
        captionLabel.text = post.captionText;
        
        gameImageView.image = UIImage(named: post.game!.game_image_url!)
        setLikesForPost(post: post)
        userImageView.image = UIImage(named: post.user!.user_image_url!)
        
        HUD.show(in: self.videoContainerView)
    }
    
    // MARK: Video Controls.

    func stopVideo(){
        self.avPlayer?.pause()
        HUD.dismiss()
    }
    
    func playVideo(){
        self.avPlayer?.play()
    }
    
    @objc func playerItemReachedEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    // MARK: KV Observer.
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                errorView.isHidden = true
                HUD.dismiss()
                if active {
                    playVideo()
                }
                else {
                    stopVideo()
                }
            case .failed:
                errorView.isHidden = false
                //show a failed icon
                HUD.dismiss()
            case .unknown:
                errorView.isHidden = false
                //show a question mark icon
                HUD.dismiss()
            @unknown default:
                //show a question mark icon
                print("Unknown")
            }
        }
    }
    
    // MARK: Call to actions.
    
    @IBAction func didClickPlayNow(_ sender: Any) {
        guard let url = URL(string: postItem.game!.game_link_url!) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func toggleLike(_ sender: UITapGestureRecognizer? = nil) {
        if postItem.liked! {
            postItem.like_count! -= 1
        }
        else {
            postItem.like_count! += 1
        }
        postItem.liked = !postItem.liked!
        setLikesForPost(post: postItem)
    }
    
    func setLikesForPost(post : Post) {
        if post.liked! {
            likeImageView.image = UIImage(named: "heart_filled")
        }
        else {
            likeImageView.image = UIImage(named: "heart_outline")
        }
        likesLabel.text = "\(post.like_count ?? 0)"
    }
}
