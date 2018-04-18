//
//  SearchCell.swift
//  BitCast
//
//  Created by Mitul Manish on 17/4/18.
//  Copyright © 2018 Mitul Manish. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    let tableViewStyle: UITableViewCellStyle = .subtitle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: tableViewStyle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
