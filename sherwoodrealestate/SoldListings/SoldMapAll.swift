import UIKit
import Parse
import MapKit
import CoreLocation

class SoldMapAll: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    var propObj = PFObject(className: PROP_CLASS_NAME)
    var annotation:MKAnnotation!
    var pointAnnotation: MKPointAnnotation!
    var pinView:MKPinAnnotationView!
    var addressItems = PFGeoPoint()
    
    
    var mapView = MKMapView()
    var mapItems = NSMutableArray()
    var recentListings = NSMutableArray()
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion!
    var mapType: MKMapType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Sold Listings Map"
        
    }
    var alisting = PFObject(className: PROP_CLASS_NAME) {
        didSet {
            
            print(alisting["title"])
            print(alisting["description"])
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mapView

        mapView.delegate = self
        if mapView.annotations.count != 0 {
            annotation = mapView.annotations[0]
            mapView.removeAnnotation(annotation)
            
        }
        
        
        
        
        
        //        self.title = "All Listings Map"
        addAnnotations()
        

        
        
        let location = CLLocationCoordinate2DMake(34.128157, -118.8763372)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 10500.0, 10500.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.centerCoordinate = location

        
    }
    func addAnnotations() {
        let annotationQuery = PFQuery(className: PROP_CLASS_NAME)
        let swOfSF = PFGeoPoint(latitude:34.0468, longitude:-118.9424)
        let neOfSF = PFGeoPoint(latitude:34.2256, longitude:-118.7997)
        
        annotationQuery.whereKey("addressItems",withinGeoBoxFromSouthwest: swOfSF, toNortheast: neOfSF)
        annotationQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                
                print("Success")
                let mappedItems = objects! as [PFObject]
                
                for mappedItem in mappedItems {
                    
                    let point = mappedItem["addressItems"] as! PFGeoPoint
                    let theTitle = mappedItem["title"] as! String
//                    let subTitle = mappedItem["cost"] as! String
                    //                    print(theTitle)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    
                    //                    print(annotation.coordinate)
                    annotation.title = theTitle
//                    annotation.subtitle = subTitle
                    
                    self.mapView.addAnnotation(annotation)
                    print(annotation.coordinate.latitude, annotation.coordinate.longitude)
                    //                    print(mappedItem)
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else{
            let pinIdent = "Pin";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
                //                let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
                let swiftColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                
                pinView.pinTintColor = swiftColor
                pinView.animatesDrop = true
                pinView.canShowCallout = true
                
                
                let rightButton = UIButton(type: UIButtonType.detailDisclosure)
                rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
                rightButton.clipsToBounds = true
                pinView.rightCalloutAccessoryView = rightButton
                
                
                //image
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
                pinView.leftCalloutAccessoryView = leftIconView
                

            }
            
            return pinView
            
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            
            let annotation = MKPointAnnotation()
            let point = PFGeoPoint()
            annotation.title = propObj["title"] as? String
            //            print(view.annotation?.title)
            
            
            annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            
            let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            
            let mapItem = MKMapItem(placemark: placemark)
            
            //            mapItem.name = propObj["name"] as? String
            mapItem.name = view.annotation!.title!
//            print(mapItem.name)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            
            
            mapItem.openInMaps(launchOptions: launchOptions)
            print(view.annotation!.coordinate)
            //            performSegue(withIdentifier: "PinDetails", sender: self)
            
            
        }
    }
    
}

