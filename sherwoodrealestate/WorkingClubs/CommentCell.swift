//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 5/2/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Parse
class CommentCell: UICollectionViewCell {
    
    var comment: PFObject? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: textView.text, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + textView.text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
            
//            image.loadImageUsingUrlString(urlString: )
        }
    }
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        //        label.numberOfLines = 0
        //        label.backgroundColor = .lightGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    let image: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
//                label.text?.uppercased()
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.sizeToFit()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        backgroundColor = .yellow
        
        addSubview(image)
        image.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        image.layer.cornerRadius = 40 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 40)

        
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: image.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 34, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

