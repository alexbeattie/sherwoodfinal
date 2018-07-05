//
//  ClubVC.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 7/2/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse

let PROP_NAME = "Sherwood"
struct Comment {
    
    //        let user: User
    
    let text: String
    //        let uid: String
    
    init(dictionary: [String: Any]) {
        //            self.user = user
        self.text = dictionary["text"] as? String ?? ""
        //            self.uid = dictionary["uid"] as? String ?? ""
    }
}

class ClubsVC : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    let listingClass = PFObject(className: PROP_NAME)
    var recentListings:[PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "sherwood")
        imageView.image = image
        navigationItem.titleView = imageView
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 0, 0)
        
        queryAllListings()
        collectionView?.reloadData()

    }
    func queryAllListings() {
        //        recentListings.removeAll()
        
        let query = PFQuery(className: PROP_NAME)
        
        query.order(byDescending: "price")
        query.cachePolicy = .networkElseCache
        
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if let objects = objects  {
                    for object in objects {
                        self.recentListings.append(object)
                        print(object)
                    }
                }
                self.collectionView?.reloadData()
                print(objects as Any)
            } else {
                print("alex")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let width = (view.frame.width - 2) / 3

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1000)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = recentListings[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(300 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentListings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        var listingClass = PFObject(className: PROP_NAME)
        listingClass = recentListings[indexPath.row]
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let imageFile = listingClass["imageFile"] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.image.image = UIImage(data: imageData)
                    }
                    //cell.activityIndicator.stopAnimating()
                }
            }
        })
        if let listingName = listingClass["title"] as? String {
            cell.nameLabel.text = listingName.uppercased()
        }
        
        if let listingPrice = listingClass["description"] as? String {
            cell.textView.text =  listingPrice
        }
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    
}

//class ClubsVCHomeCell: BaseCell {
//    var listing: PFObject? {
//        didSet {
//
//        }
//    }
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Best New Apps"
//        //        label.text?.uppercased()
//        label.font = UIFont(name: "Avenir Heavy", size: 17)
//        label.sizeToFit()
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    let image: CustomImageView = {
//        let iv = CustomImageView()
//        //            iv.image = UIImage(named:"pic")
//        //        iv.backgroundColor = UIColor.black
//        iv.contentMode = .scaleAspectFill
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.layer.masksToBounds = true
//        return iv
//    }()
//
//    let costLabel: UILabel = {
//        let label = UILabel()
//        label.text = " "
//        label.font = UIFont(name: "Avenir Heavy", size: 16)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.textColor = UIColor.black
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
//    let textView: UITextView = {
//        let tv = UITextView()
//        tv.font = UIFont(name: "Avenir Light", size: 16)
//        tv.textColor = UIColor.black
//        tv.text = "SAMPLE DESCRIPTION"
//        tv.isEditable = false
//        tv.isScrollEnabled = false
//        return tv
//    }()
//
//
//
//
//
//
//
//    func setupThumbNailImage() {
//
//
////        if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri1024 {
////            imageView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
////        }
//
//    }
//    override func setupViews() {
//        //        backgroundColor = UIColor.clear
//        autoresizingMask = .flexibleHeight
//
//        addSubview(image)
//        image.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(nameLabel)
//        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(textView)
//        textView.anchor(top: topAnchor, left: leftAnchor, bottom: image.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
//        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
//        addConstraintsWithFormat(format: "V:|-4-[v0(200)]|", views: textView)
//
//
////        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: nameLabel)
////        addConstraintsWithFormat(format: "V:[v0]-20-|", views: nameLabel)
//
////        addConstraintsWithFormat(format: "H:|[v0]|", views: image)
////        addConstraintsWithFormat(format: "V:|[v0]|", views: image)
//
//
////        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
////        addConstraintsWithFormat(format: "V:|[v0]-4-[v1]|", views: image,textView)
//
////        image.anchor(top: topAnchor, left: leftAnchor, bottom: nameLabel.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//
//
//    }
//}

