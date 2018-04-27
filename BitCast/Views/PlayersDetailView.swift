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
    
    enum PlayerControlType: Double {
        case forward = 15, rewind = -15
        
        func calculateTime(for player: AVPlayer) -> CMTime {
            let playerTime = player.currentTime()
            switch self {
            case .forward:
                return playerTime + CMTime(seconds: rawValue, preferredTimescale: 1)
            case .rewind:
                return playerTime + CMTime(seconds: rawValue, preferredTimescale: 1)
            }
        }
    }
    
    // MARK:- IBOutlets & Actions
    
    @IBOutlet weak var episodeProgressSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBAction func episodeProgressBarTouched(_ sender: UISlider) {
        let intendedMovement = sender.value
        guard let totalEpisodeDuration = player.currentItem?.duration else {
            return
        }
        let totalDurationInSeconds = CMTimeGetSeconds(totalEpisodeDuration)
        
        let newValue = Float64(intendedMovement) * totalDurationInSeconds
        let newTime = CMTime(seconds: newValue, preferredTimescale: 1)
        player.seek(to: newTime)
    }
    
    @IBAction func volumeSliderTouched(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func rewindButtonPressed(_ sender: UIButton) {
        let newTime = PlayerControlType.rewind.calculateTime(for: player)
        player.seek(to: newTime)
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        let newTime = PlayerControlType.forward.calculateTime(for: player)
        player.seek(to: newTime)
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if player.timeControlStatus == .playing, playButton.imageView?.image?.hashValue == #imageLiteral(resourceName: "pause").hashValue  {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
            animateEpisodeImageView(withAnimationType: .shrink)
        } else if player.timeControlStatus == .paused, playButton.imageView?.image?.hashValue == #imageLiteral(resourceName: "play").hashValue{
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
            animateEpisodeImageView(withAnimationType: .expand)
        }
    }
    
    var episode: Episode! {
        didSet {
            self.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
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
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            animateEpisodeImageView(withAnimationType: .shrink, supportsExplicitAnimation: false)
        }
    }
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthor: UILabel!
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    enum AnimationType {
        case expand, shrink
    }
    
    private func animateEpisodeImageView(withAnimationType animationType: AnimationType, supportsExplicitAnimation: Bool = true) {
        let transform: CGAffineTransform!
        switch animationType {
        case .shrink:
            let scale: CGFloat = 0.7
            let shrinkTransform : CGAffineTransform = CGAffineTransform(scaleX: scale, y: scale)
            transform = shrinkTransform
        case .expand:
            transform = .identity
        }
        
        if supportsExplicitAnimation {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                self?.episodeImageView.transform = transform
            })
        } else {
            self.episodeImageView.transform = transform
        }
    }
    
    fileprivate func observePlayAndPause() {
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.animateEpisodeImageView(withAnimationType: .expand)
            self?.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    private func observeEpisodeProgress() {
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toTimeInHourMinuteAndSeconds()
            self?.totalTimeLabel.text = self?.player.currentItem?.duration.toTimeInHourMinuteAndSeconds() ?? ""
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        let totatEpisodeDuration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let progressPercentage = currentTimeInSeconds / totatEpisodeDuration
        episodeProgressSlider.value = Float(progressPercentage)
    }
    
    override func awakeFromNib() {
        episodeImageView.layer.cornerRadius = 4
        episodeImageView.clipsToBounds = true
        
        observePlayAndPause()
        observeEpisodeProgress()
    }
}
