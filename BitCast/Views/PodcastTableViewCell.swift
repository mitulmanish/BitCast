//
//  PodcastTableViewCell.swift
//  BitCast
//
//  Created by Mitul Manish on 18/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        podcastImageView.layer.cornerRadius = 4
        podcastImageView.clipsToBounds = true
    }
    
    func configureCell(trackName: String, artistName: String, episodeCount: Int, imageUrl: String) {
        self.trackName.text = trackName
        self.artistName.text = artistName
        self.episodeCount.text = "\(episodeCount)"
        self.podcastImageView.sd_setShowActivityIndicatorView(true)
        guard let url = URL(string: imageUrl) else {
            return
        }
        self.podcastImageView.sd_setImage(with: url, completed: nil)
    }
}
