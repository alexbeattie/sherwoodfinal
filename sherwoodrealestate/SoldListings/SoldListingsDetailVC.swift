//
//  SoldListingsDetailsVC.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 7/4/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import Parse
import MapKit

class SoldListingsDetailsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {
    let slidesId = "slidesId"
    let slidesTitleId = "slidesTitleId"
    let soldDetailId = "soldDetailId"
    let soldMapId = "soldMapId"
    let soldOneImageId = "soldOneImageId"
    
    
    //map stuff
    var addressItems = PFGeoPoint()
    
//    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var region: MKCoordinateRegion!
    var mapType: MKMapType!
    
    
    var alisting = PFObject(className: PROP_CLASS_NAME) {
        didSet {
            
            print(alisting["title"])
            print(alisting["description"])
            
        }
    }
    override func viewDidLoad() {
        collectionView?.register(SoldListingSlides.self, forCellWithReuseIdentifier: slidesId)
        collectionView?.register(SoldTitleCell.self, forCellWithReuseIdentifier: slidesTitleId)
        collectionView?.register(SoldAppDetailDescriptionCell.self, forCellWithReuseIdentifier: soldDetailId)
        collectionView?.register(SoldMapCell.self, forCellWithReuseIdentifier: soldMapId)
        
        collectionView?.register(OneImageCell.self, forCellWithReuseIdentifier: soldOneImageId)
        collectionView?.backgroundColor = .white
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
        annoView.pinTintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.animatesDrop = true
        annoView.canShowCallout = true
        let swiftColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        annoView.centerOffset = CGPoint(x: 100, y: 400)
        annoView.pinTintColor = swiftColor
        
        // Add a RIGHT CALLOUT Accessory
        let rightButton = UIButton(type: UIButtonType.detailDisclosure)
        rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
        rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
        rightButton.clipsToBounds = true
        rightButton.tintColor = #colorLiteral(red: 0.5137254902, green: 0.8470588235, blue: 0.8117647059, alpha: 1)
        
        annoView.rightCalloutAccessoryView = rightButton
        
        
        let leftIconView = UIImageView()
        leftIconView.contentMode = .scaleAspectFill
        if let thumbImage = alisting["imageFile"] as? PFFile {
            thumbImage.getDataInBackground() { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        leftIconView.image = UIImage(data:imageData)
                        
                        
                    }
                }
            }
        }
        let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
        leftIconView.bounds = newBounds
        annoView.leftCalloutAccessoryView = leftIconView
        
        
        return annoView
        
    }

    
    func goOutToGetMap() {
        let addressItems = PFGeoPoint(latitude: (self.alisting["addressItems"] as AnyObject).latitude, longitude: (self.alisting["addressItems"] as AnyObject).longitude)
        if let theLocation = self.alisting["addressItems"] as? PFGeoPoint {
            CLLocationCoordinate2DMake(addressItems.latitude, addressItems.longitude)
            print(theLocation)
        }
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake((self.alisting["addressItems"] as AnyObject).latitude, (self.alisting["addressItems"] as AnyObject).longitude)
        
        let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        
        let item = MKMapItem(placemark: placemark)
        item.name = self.alisting["title"] as? String
        item.openInMaps (launchOptions: [MKLaunchOptionsMapTypeKey: 2,
                                         MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: placemark.coordinate),
                                         MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let alertController = UIAlertController(title: nil, message: "Driving directions", preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "Get Directions", style: .default) { (action) in
            self.goOutToGetMap()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
    }

    
    
    
    
    
    
    
    
    
    
    
    func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, attributedText.string.count)
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
        
        if let desc = alisting["description"] as? String {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        }
        
        return attributedText
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: slidesTitleId, for: indexPath) as! SoldTitleCell
            if let theAddress = alisting["title"] as? String {
                cell.nameLabel.text = theAddress.uppercased()
            }
            return cell
        }
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: soldDetailId, for: indexPath) as! SoldAppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
            
        }
        if indexPath.item == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: soldMapId, for: indexPath) as! SoldMapCell
            cell.mapView.mapType = .standard
            cell.mapView.delegate = self
            let addressItems = PFGeoPoint(latitude: (alisting["addressItems"] as AnyObject).latitude, longitude: (alisting["addressItems"] as AnyObject).longitude)
            
            let location = CLLocationCoordinate2DMake(addressItems.latitude, addressItems.longitude)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 27500.0, 27500.0)
            cell.mapView.setRegion(coordinateRegion, animated: true)
            cell.mapView.centerCoordinate = location
            let pin = MKPointAnnotation()
            
            
            pin.coordinate = location
            pin.title = alisting["title"] as? String
      
            DispatchQueue.main.async(execute: { () -> Void in
                cell.mapView.addAnnotation(pin)
                cell.mapView.selectAnnotation(pin, animated: true)
            })
            
            return cell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: soldOneImageId, for: indexPath) as! OneImageCell

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

        return cell
    }
    
    
    
    
    
    
    
    
    
    
    //spacing stuff
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
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
        if indexPath.item == 3 {
            
            
            return CGSize(width: view.frame.width, height: 300)
            
        }
        return CGSize(width: view.frame.width, height: 300)
    }
    
}

class SoldTitleCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont(name: "Avenir Heavy", size: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    override func setupViews() {
        
        
        addSubview(viewContainer)
        addSubview(nameLabel)
        //        addSubview(costLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: viewContainer)
        addConstraintsWithFormat("V:|[v0(40)]|", views: viewContainer)
        
        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat("V:|[v0]-8-|", views: nameLabel)
        
    }
}

class SoldAppDetailDescriptionCell: BaseCell {
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir Light", size: 16)
        
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
    
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat("H:|-14-[v0]-14-|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
    }
}
class OneImageCell : BaseCell  {
    
    let image: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named:"pic")
        //        iv.backgroundColor = UIColor.black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()

    override func setupViews() {

        addSubview(image)
        addConstraintsWithFormat(format: "H:|[v0]|", views: image)
        addConstraintsWithFormat(format: "V:|[v0]|", views: image)

    }
}


class SoldMapCell: BaseCell, MKMapViewDelegate  {
    
    var mapView = MKMapView()
    
    
    override func setupViews() {
        
        addSubview(mapView)
        addConstraintsWithFormat("H:|[v0]|", views: mapView)
        addConstraintsWithFormat("V:|[v0]|", views: mapView)
    }
}


