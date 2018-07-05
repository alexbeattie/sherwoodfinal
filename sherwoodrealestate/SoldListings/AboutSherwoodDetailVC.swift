//
//  AboutSherwoodDetailVC.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 6/25/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse
import MapKit
//let PROP_CLASS_NAME = "AboutSherwoodVC"

class AboutSherwoodDetailVC: UICollectionViewController, MKMapViewDelegate  {
    let cellId = "cellId"
    var propObj = PFObject(className: PROP_CLASS_NAME)
    var listingClass = PFObject(className: PROP_CLASS_NAME)
    
    let adescriptionId = "descriptionId"
    let headerId = "headerId"
    let atitleId = "titleId"
    let mainId = "mainId"
    
    
    var alisting = PFObject(className: PROP_CLASS_NAME) {
        didSet {
            // var listingClass = PFObject(className: PROP_CLASS_NAME)
            
            
            
            
            //            print(listing)
            print(alisting["title"])
            print(alisting["description"])
            
            //            if listing?.StandardFields.Photos != nil {
            //                return
            //            }
            //            if listing?.StandardFields.VirtualTours != nil {
            //                return
            //            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.register(ListingSlides.self, forCellWithReuseIdentifier: cellId)
        //        collectionView?.register(ATitleCell.self, forCellWithReuseIdentifier: atitleId)
        collectionView?.register(OAppDetailDescriptionCell.self, forCellWithReuseIdentifier: adescriptionId)
        collectionView?.showsVerticalScrollIndicator = false
        
        collectionView?.backgroundColor = UIColor.white
        
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adescriptionId, for: indexPath) as! OAppDetailDescriptionCell
        
        //        var listingClass = PFObject(className: "AboutSherwoodVC")
        //        listingClass = recentListings[indexPath.row]
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let imageFile = self.alisting["imageFile"] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.image.image = UIImage(data: imageData)
                    }
                    //cell.activityIndicator.stopAnimating()
                }
            }
        })
        
        if let theAddress = alisting["title"] as? String {
            cell.nameLabel.text = theAddress.uppercased()
        }
        if let theText = alisting["description"] as? String {
            cell.textView.text = theText
        }
        
        return cell
        
    }
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransition(to: size, with: coordinator)
    //        collectionView?.collectionViewLayout.invalidateLayout()
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
}
class OAppDetailDescriptionCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        //        label.attributedText =
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = ""
//        label.font = UIFont.systemFont(ofSize: 16)
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        //        label.textAlignment = .center
        //        label.attributedText =
        label.numberOfLines = 0
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir Heavy", size: 14)

        tv.text = "SAMPLE DESCRIPTION"
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    var image: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(image)
        addSubview(nameLabel)
        addSubview(textView)
        
//        addConstraintsWithFormat("H:|[v0(380)]|", views: image)
//        addConstraintsWithFormat("V:[v0(200)]", views: image)
//
//        addConstraintsWithFormat("V:|-200-[v0(44)]-20-|", views: nameLabel)
//        addConstraintsWithFormat("H:|[v0(380)]|", views: nameLabel)
//
//        addConstraintsWithFormat("V:|-250-[v0(800)]|", views: textView)
//        addConstraintsWithFormat("H:|-8-[v0(360)]-16-|", views: textView)
//
        
        
        image.anchorTwo(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: nil, trailing: superview?.trailingAnchor)
        image.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        image.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        //        image.anchorTwo(top: image.topAnchor, leading: image.leadingAnchor, bottom: nil, trailing: image.trailingAnchor, size: .init(width: 400, height: 200))
        //        nameLabel.anchor(top: image.bottomAnchor, left: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, paddingTop: <#T##CGFloat#>, paddingLeft: <#T##CGFloat#>, paddingBottom: <#T##CGFloat#>, paddingRight: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        //        nameLabel.anchorTwo(top: nameLabel.bottomAnchor, leading: image.leadingAnchor, bottom: nil, trailing: image.trailingAnchor,size: .init(width: 400, height: 200))
        //        image.anchorSize(to: superview!)
        //        addConstraintsWithFormat("H:|[v0(200)]|", views: image)
        //        addConstraintsWithFormat("V:|-8-[v0(200)]-8-|", views: image)
        
        //        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        //        addConstraintsWithFormat("V:|-8-[v0]-8-|", views: nameLabel)
        //
        //        addConstraintsWithFormat("H:|[v0(200)]|", views: textView)
        //        addConstraintsWithFormat("V:|[v0(200)]-2-[v1(200)]-8-|", views: nameLabel, textView)
        //
        //        addConstraintsWithFormat("H:|-14-[v0(200)]-14-|", views: dividerLineView)
        //
        //        addConstraintsWithFormat("V:|-4-[v0(200)]-4-[v1(1)]|", views: textView, dividerLineView)
    }
}


extension UIView {
    
    func fillSuperView() {
        anchorTwo(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func anchorTwo(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}





