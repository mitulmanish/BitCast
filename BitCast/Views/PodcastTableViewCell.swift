//
//  PodcastTableViewCell.swift
//  BitCast
//
//  Created by Mitul Manish on 18/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(trackName: String, artistName: String, episodeCount: Int) {
        self.trackName.text = trackName
        self.artistName.text = artistName
    }
}
