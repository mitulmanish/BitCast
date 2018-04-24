//
//  PodcastDetailTableViewCell.swift
//  BitCast
//
//  Created by Mitul Manish on 21/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit

class PodcastDetailTableViewCell: UITableViewCell {
 
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var episodeName: UILabel! {
        didSet {
            episodeName.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var episodeDescription: UILabel! {
        didSet {
            episodeDescription.numberOfLines = 2
        }
    }
    
    override func awakeFromNib() {
        episodeImageView.layer.cornerRadius = 4
        episodeImageView.clipsToBounds = true
    }
    
    func configure(publishedDate: Date, episodeName: String, episodeDescription: String, episodeImagUrl: String) {
        self.publishedDate.text = publishedDate.stringify()
        self.episodeName.text = episodeName
        self.episodeDescription.text = episodeDescription
        guard let url = URL(string: episodeImagUrl) else {
            return
        }
        self.episodeImageView.sd_setImage(with: url, completed: nil)
    }
}
