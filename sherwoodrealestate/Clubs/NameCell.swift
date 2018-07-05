//
//  NameCell.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 6/28/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse

class NameCell : BaseCell {
    var recentListings: PFObject? {
        didSet {
        }
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
    }
}

