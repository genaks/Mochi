//
//  PostTableViewCell.swift
//  Mochi
//
//  Created by Akshay Jain on 11/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit
import AVKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpPlayerLayer()
    }
    
    func setUpPlayerLayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 5
        avPlayer?.actionAtItemEnd = .none
        
        avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: self.videoContainerView.frame.width,
                                           height: self.videoContainerView.frame.size.height)
        self.backgroundColor = .clear
        self.videoContainerView.layer.insertSublayer(avPlayerLayer!, at: 0)
    }
    
    func configureCellForPost(post : Post) {
        videoPlayerItem = AVPlayerItem.init(url : post.video_url)
        usernameLabel.text = post.username;
        captionLabel.text = post.captionText;
        likesLabel.text = "\(post.like_count ?? 0)"
        
        gameImageView.image = UIImage(named: "DR_Banner")
        
        if post.liked! {
            likeImageView.image = UIImage(named: "heart_filled")
        }
        else {
            likeImageView.image = UIImage(named: "heart_outline")
        }
    }
    
    func stopVideo(){
        self.avPlayer?.pause()
    }
    
    func playVideo(){
        self.avPlayer?.play()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
