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
    
    func stringify(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func configure(publishedDate: Date, episodeName: String, episodeDescription: String) {
        self.publishedDate.text = stringify(date: publishedDate)
        self.episodeName.text = episodeName
        self.episodeDescription.text = episodeDescription
    }
}
