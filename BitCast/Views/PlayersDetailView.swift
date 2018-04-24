//
//  PlayersDetailView.swift
//  BitCast
//
//  Created by Mitul Manish on 23/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit
import AVKit

class PlayersDetailView: UIView {
    
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBAction func rewindButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.pause()
        } else {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.play()
        }
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
    }
    
    var episode: Episode! {
        didSet {
            self.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.episodeTitleLabel.text = episode.title
            self.episodeAuthor.text = episode.author
            guard let imageUrl = episode.imageUrl, let url = URL(string: imageUrl) else {
                return
            }
            self.episodeImageView.sd_setImage(with: url, completed: nil)
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
       let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else {
            print("Invalid steam url")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthor: UILabel!
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        episodeImageView.layer.cornerRadius = 4
        episodeImageView.clipsToBounds = true
    }
}
