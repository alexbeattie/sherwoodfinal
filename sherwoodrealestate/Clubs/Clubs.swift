//
//  Clubs.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 6/18/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse

class Clubs: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let descriptionId = "descriptionId"
    let headerId = "headerId"
    let titleId = "titleId"
    let mapId = "mapId"
    let slidesId = "slidesId"
    let clubId = "clubId"
    var recentListings:[PFObject] = []
    var listingClass = PFObject(className: "Sherwood")
//    listingClass = recentListings[indexPath.row]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(ClubsTitleCell.self, forCellWithReuseIdentifier: titleId)
        collectionView?.register(ClubsDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionId)
        collectionView?.register(ClubsMapCell.self, forCellWithReuseIdentifier: clubId)
        collectionView?.register(ClubsSlides.self, forCellWithReuseIdentifier: cellId)

        collectionView?.backgroundColor = UIColor.white

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "sherwood")
        imageView.image = image
        navigationItem.titleView = imageView

        queryAllListings()
        
        collectionView?.reloadData()
        
    }
    
    
    var cellSelected : Int = 0
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelected = indexPath.item
        var listingClass = PFObject(className: "Sherwood")
//        listingClass = recentListings[indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        let newDetailViewController = AboutSherwoodDetailVC(collectionViewLayout: layout)
        newDetailViewController.alisting = listingClass
        
        navigationController?.pushViewController(newDetailViewController, animated: true)
        
        
        
        print("tapped")
        
    }
    
    func queryAllListings() {
        recentListings.removeAll()
        
        let query = PFQuery(className: "Sherwood")
        
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
    func descriptionAttributedText() -> NSAttributedString {
        //let indexPath =
        //var listingClass = PFObject(className: "Sherwood")
        //listingClass = recentListings[indexPath.row]

        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, attributedText.string.count)
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
       // var listingClass = PFObject(className: "Sherwood")
//                listingClass = recentListings[indexPath.row]
//                cell.textView.text = listingClass["description"] as? String
        
//        if let desc = listingClass["description"] as? String {
//            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
//        }
        
        return attributedText
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            return CGSize(width: view.frame.width, height: 30)
        }
        if indexPath.item == 2 {
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 50)
        }
        return CGSize(width: view.frame.width, height: 300)
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
        
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleId, for: indexPath) as! ClubsTitleCell
           // cell.listing = listing
            var listingClass = PFObject(className: "Sherwood")
            listingClass = recentListings[indexPath.row]
            
            if let listingName = listingClass["title"] as? String {
                cell.nameLabel.text = listingName
            }
            return cell
        }
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionId, for: indexPath) as! ClubsDetailDescriptionCell
            var listingClass = PFObject(className: "Sherwood")
            listingClass = recentListings[indexPath.row]

            if let listingPrice = listingClass["description"] as? String {
                cell.textView.text =  listingPrice
                print("This is the \(listingPrice)")
            }
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: clubId, for: indexPath) as! ClubsMapCell
        var listingClass = PFObject(className: "Sherwood")
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
        return cell
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
}
    
    class ClubsTitleCell: BaseCell {
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
            
            addSubview(nameLabel)

            
            addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
            addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
            
        }
    }

    class ClubsDetailDescriptionCell: BaseCell {
        var recentListings: PFObject? {
            didSet {
            }
        }
        
        let textView: UITextView = {
            let tv = UITextView()
            tv.font = UIFont(name: "Avenir Light", size: 16)
            
            tv.text = "SAMPLE "
            tv.isEditable = false
            tv.isScrollEnabled = false
            return tv
        }()
        
        let dividerLineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
            return view
        }()
        
        override func setupViews() {
            super.setupViews()
            addSubview(textView)
            addSubview(dividerLineView)
            
            addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
            addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
            
            addConstraintsWithFormat("V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
        }
    }

class ClubsMapCell: BaseCell  {
    
//    var mapView = MKMapView()
    
    var listing: Listing? {
        didSet {
        }
    }
    let image: CustomImageView = {
        let iv = CustomImageView()
        //            iv.image = UIImage(named:"pic")
        //        iv.backgroundColor = UIColor.black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    

    
    override func setupViews() {
        
        addSubview(image)
        addConstraintsWithFormat("H:|[v0]|", views: image)
        addConstraintsWithFormat("V:|[v0]|", views: image)
    }
}



