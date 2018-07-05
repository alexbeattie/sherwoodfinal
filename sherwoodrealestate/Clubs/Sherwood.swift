//
//  Sherwood.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 6/26/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse


class SherwoodCell: BaseCell {
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
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "400"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    let image: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(image)
        
        addSubview(nameLabel)
        addSubview(costLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat("V:|[v0]-8-|", views: nameLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: costLabel)
        addConstraintsWithFormat("V:[v0]-2-|", views: costLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: image)
        addConstraintsWithFormat(format: "V:|[v0]|", views: image)
        
    }
}
