//
//  RestaurantDetail.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 17/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//
import UIKit
import MapKit

class RestaurantDetail: UIViewController, UIScrollViewDelegate, HorizontaScrollDelegate, MKMapViewDelegate {
   //, CLLocationManagerDelegate removed
    var scrollView: UIScrollView!
    var containerView = UIView()
    var restrau:RestaurantModel!
    var imageArr : [String] = ["deli2","deli3","deli4"]
    var menu : [String] = ["menu1","menu2","menu2","menu1","menu2","menu1","menu2","menu1"]
    var delegateCount:Int = 0
    let mapView: MKMapView! = MKMapView()
    var annotations:[RestrauUserCoordinate]!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonOne: UIButton = UIButton(frame:CGRect(x:self.view.frame.size.width/2-133, y:30, width:7, height:10))
        buttonOne.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
//        buttonOne.addTarget(self, action: #selector(RestaurantDetail.newFunc()), for: UIControlEvents.touchUpInside)
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        
        let restaurantName = UILabel(frame: CGRect(x: 15, y: 163, width:160, height: 40))
        restaurantName.text = "Smoke House Deli"
        restaurantName.font = UIFont(name: "Bariol-Regular", size: 18)
        restaurantName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let cuisines = UILabel(frame: CGRect(x: 15, y: 187, width:90, height: 30))
        cuisines.text = "Europian,Italian"
        cuisines.font = UIFont(name: "Bariol-Light", size: 12)
        cuisines.textColor = UIColor.darkGray
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width:view.frame.width, height:1500)
        
        containerView = UIView()
    
        let imageUsr3 = UIImage(named: "stars")
        let imageViewStars = UIImageView(image: imageUsr3)
        imageViewStars.frame = CGRect(x: 15, y: 227, width: 120, height: 15)
        
        let rating = UILabel(frame: CGRect(x: 160, y: 220, width:25, height: 30))
        rating.text = "4.2"
        rating.font = UIFont(name: "Bariol-Regular", size: 15)
        rating.textColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
        rating.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        let imageGreen = "dollar_green.png"
        let imageGray = "dollar_grey.png"
        let imageGn = UIImage(named: imageGreen)
        let imageGy = UIImage(named: imageGray)
        let imageView1 = UIImageView(image: imageGn!)
        let imageView2 = UIImageView(image: imageGn!)
        let imageView3 = UIImageView(image: imageGy!)
        imageView1.frame = CGRect(x: 255, y: 180, width: 7, height: 13)
        imageView2.frame = CGRect(x: 270,y: 180, width: 7, height: 13)
        imageView3.frame = CGRect(x: 285, y: 180, width: 7, height: 13)
        
        let imageClock = "yellowclock.png"
        let imageClk = UIImage(named: imageClock)
        let imageViewClock = UIImageView(image: imageClk)
        
        let imageMap = "map_icon.png"
        let imageMp = UIImage(named: imageMap)
        let imageViewLocation = UIImageView(image: imageMp)
        
        let imageWifi = "wifi_icon.png"
        let imageWf = UIImage(named: imageWifi)
        let imageViewWifi = UIImageView(image: imageWf)
        
        let imageDelivery = "food-delivery.png"
        let imageDlvry = UIImage(named: imageDelivery)
        let imageViewDelivery = UIImageView(image: imageDlvry)
        
        imageViewClock.frame = CGRect(x: 30, y: 270, width: 14, height: 14)
        imageViewLocation.frame = CGRect(x: 110, y: 268, width: 15, height: 17)
        imageViewWifi.frame = CGRect(x: 190, y: 270, width: 17, height: 12)
        imageViewDelivery.frame = CGRect(x: 270, y: 268, width: 13, height: 17)
        
        
        let ocTime = UILabel(frame: CGRect(x: 18, y: 277, width:60, height: 40))
        ocTime.text = "upto 11 PM"
        ocTime.textColor = UIColor.gray
        ocTime.font = UIFont(name: "Bariol-Regular", size: 10)
        
        let locationTime = UILabel(frame: CGRect(x: 106, y: 277, width:40, height: 40))
        locationTime.text = "2.5 m"
        locationTime.textColor = UIColor.gray
        locationTime.font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        let wifi = UILabel(frame: CGRect(x: 190, y: 277, width:40, height: 40))
        wifi.text = "Wifi"
        wifi.textColor = UIColor.gray
        wifi.font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        let delivery = UILabel(frame: CGRect(x: 260, y: 277, width:40, height: 40))
        delivery.text = "Delivery"
        delivery.textColor = UIColor.gray
        delivery.font = UIFont(name: "Bariol-Regular", size: 10)
        
        let hScroll = HorizontalScroll(frame:CGRect(x:0, y:0, width: view.frame.width, height:150))
        hScroll.backgroundColor = UIColor.gray
        hScroll.delegate = self
        
//        let honorLabel:UILabel = UILabel(frame:CGRect(x:20, y:470, width:80,height:40))
//        honorLabel.text = "HONORS"
//        honorLabel.textColor = UIColor.darkGray
//        honorLabel.font = UIFont(name: "Bariol-Thin", size: 12)
//        
//        let imageHonors = ["honor1","honor2","honor3","honor4"]
//        var offset: Int = 10
//        for index in 0 ... (imageHonors.count - 1) {
//            let imageHonor = UIImage(named: imageHonors[index])
//            let imageViewHonor = UIImageView(image: imageHonor)
//            imageViewHonor.frame = CGRect(x: offset, y: 510, width: 60, height: 60)
//            offset = offset + 80
//            containerView.addSubview(imageViewHonor)
//        }
        
        let topLabel = UILabel(frame:CGRect(x:20, y:330 , width:140, height:40))
        topLabel.text = "TOP THREE DISH"
        topLabel.textColor = UIColor.darkGray
        topLabel.font = UIFont(name: "Bariol-Thin", size: 12)
        
        var offset: Int = 0
        let topImgArr = ["choice1","choice2","choice3"]
        let textArr = ["Thai Coconut Curry Soup","Grilled Chicken Burger","Choco Berry Saver"]
        for index in 0...(topImgArr.count - 1) {
            let imageTop = UIImage(named:topImgArr[index])
            let imageViewTop = UIImageView(image: imageTop)
            imageViewTop.frame = CGRect(x:20, y:375 + offset , width:30, height:30)
            let labelImage = UILabel(frame:CGRect(x:72,y:370+offset,width:160,height:40))
            labelImage.text = textArr[index]
            labelImage.font = UIFont(name: "Bariol-Bold", size: 15)
            offset = offset + 50
            containerView.addSubview(labelImage)
            containerView.addSubview(imageViewTop)
        }
        
        mapView.frame = CGRect(x:0, y:400 + offset, width:Int(view.frame.size.width), height:100)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        containerView.addSubview(mapView)
        
        annotations = getMapAnnotations()
        zoomToRegion(lat: annotations[0].coordinate.latitude, longFor:annotations[0].coordinate.longitude)
        mapView.addAnnotations(annotations)
        
        mapView.delegate = self
        
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
        // Connect all the mappoints using Poly line.
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        let polyline = MKPolyline(coordinates: points, count: points.count)
        mapView.add(polyline)
//        showRouteOnMap()
        
        let addLabel = UILabel(frame:CGRect(x:20, y:510 + offset , width:250, height:40))
        addLabel.numberOfLines = 2
        addLabel.text = "128/54/10, Above A2B, Opposite IIM - B , Dasarapalya, \nBannerghatta Road , Bangalore"
        addLabel.textColor = UIColor.darkGray
        addLabel.font = UIFont(name: "Bariol-Regular", size: 10)
    
        
        let menuLabel = UILabel(frame:CGRect(x:20, y:550 + offset , width:50, height:40))
        menuLabel.text = "Menu"
        menuLabel.textColor = UIColor.darkGray
        menuLabel.font = UIFont(name: "Bariol-Thin", size: 14)
        
        let hMenuScroll = HorizontalScroll(frame:CGRect(x:15, y:595 + offset, width: Int(view.frame.size.width), height:80))
        hMenuScroll.backgroundColor = UIColor.white
        hMenuScroll.delegate = self
        
        let review = UILabel(frame:CGRect(x:25, y:640 + offset , width:130, height:40))
        review.text = "OFFICIAL REVIEW"
        review.textColor = UIColor.darkGray
        review.font = UIFont(name: "Bariol-Thin", size: 14)

        
        let imageViewStar = UIImageView(image: UIImage(named:"star"))
        imageViewStar.frame = CGRect(x:23, y:740 + offset, width:13 , height:13)
        
        
        let anotherRating = UILabel(frame: CGRect(x: 48, y: 728 + offset, width:30, height: 35))
        anotherRating.text = "4.2"
        anotherRating.font = UIFont(name: "Bariol-Regular", size: 15)
        anotherRating.textColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
        anotherRating.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        let textView = UILabel(frame: CGRect(x:25.0, y:Double(730 + offset), width:300.0, height:220.0))
        textView.numberOfLines = 15
        textView.text = "I had only heard of Fattoush until now and recently dined here for a \nbloggers meet along with a few foodie friends.\n\nThis place serves both Buffet and Ala Carte,so my review is based on \nthe Ala Carte experience ONLY. \n\nThe decor is nice and beautiful with two dining sections. I didnt know it was actually a pretty spacious place and easily accommodate a big crowd! \nTheres also a tiny children's play area which was very pleasing to see. So its a kids friendly place."
        textView.font = UIFont(name: "Bariol-Thin", size: 11)
        
        
        let userreviews = UILabel(frame: CGRect(x: 23, y: 925 + offset, width:130, height: 40))
        userreviews.text = "USER REVIEWS"
        userreviews.textColor = UIColor.darkGray
        userreviews.font = UIFont(name: "Bariol-Thin", size: 14)
        
        
        let hReviewScroll = HorizontalScroll(frame:CGRect(x:23, y:970 + offset, width: Int(view.frame.size.width), height:250))
        hReviewScroll.backgroundColor = UIColor.white
        hReviewScroll.delegate = self
        
        let reviewButton = UIImageView(frame: CGRect(x:18, y:1220 + offset, width:300, height:100))
        reviewButton.image = UIImage(named:"reviewRect")
        let label = UILabel(frame:CGRect(x:90, y:20, width:200, height:50))
        label.text = "Write your own review"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Bariol-Regular", size: 14)
        let penImage = UIImageView(image:UIImage(named:"pen"))
        penImage.frame = CGRect(x:66, y:40, width:10, height:10)
        reviewButton.addSubview(penImage)
        reviewButton.addSubview(label)
        
        scrollView.addSubview(containerView)
        
        view.addSubview(buttonOne)
        view.addSubview(scrollView)
        containerView.addSubview(restaurantName)
        containerView.addSubview(cuisines)
        containerView.addSubview(imageViewStars)
        containerView.addSubview(rating)
        containerView.addSubview(imageView1)
        containerView.addSubview(imageView2)
        containerView.addSubview(imageView3)
        containerView.addSubview(imageViewClock)
        containerView.addSubview(imageViewDelivery)
        containerView.addSubview(imageViewWifi)
        containerView.addSubview(imageViewLocation)
        containerView.addSubview(ocTime)
        containerView.addSubview(locationTime)
        containerView.addSubview(wifi)
        containerView.addSubview(delivery)
        containerView.addSubview(hScroll)
        containerView.addSubview(imageViewStar)
        delegateCount += 1
        containerView.addSubview(hMenuScroll)
        delegateCount += 1
        
//        containerView.addSubview(honorLabel)
        containerView.addSubview(topLabel)
        containerView.addSubview(menuLabel)
        containerView.addSubview(addLabel)
        containerView.addSubview(review)
        containerView.addSubview(anotherRating)
        containerView.addSubview(textView)
        containerView.addSubview(userreviews)
        containerView.addSubview(hReviewScroll)
        containerView.addSubview(reviewButton)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func numberOfScrollViewElements() -> Int {
        if delegateCount == 0 {
            return imageArr.count - 1
        }else if delegateCount == 1 {
            return menu.count - 1
        }else {
            return 3
        }
    }
    
    func elementAtScrollViewIndex(index: Int) -> UIView {
        var newview:UIView = UIView()
        if delegateCount == 0  {
            newview = UIView(frame:CGRect(x:0, y:0, width:Int(view.frame.size.width), height:230))
            
            let moreImage = UIImage(named: imageArr[index])
            let moreImageView = UIImageView(image:moreImage)
            moreImageView.frame = newview.frame
            newview.addSubview(moreImageView)
        } else if delegateCount == 1 {
            newview = UIView(frame:CGRect(x:0, y:0, width:Int(view.frame.size.width)/3 - 30, height:100))
            let moreImage = UIImage(named: menu[index])
            let moreImageView = UIImageView(image:moreImage)
            moreImageView.frame = newview.frame
            newview.addSubview(moreImageView)
        } else {
            newview = UIView(frame:CGRect(x:0, y:10, width:Int(view.frame.size.width) - 100, height:200))
            newview.backgroundColor = UIColor.white
            newview.layer.shadowColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0).cgColor
            newview.layer.shadowOpacity = 1
            newview.layer.shadowOffset = CGSize.zero
            newview.layer.shadowRadius = 10
            
            let imageUser1 = "user3.png"
            let imageUsr1 = UIImage(named: imageUser1)
            let imageViewUser1 = UIImageView(image: imageUsr1)
            imageViewUser1.frame = CGRect(x: 20, y: 20, width: 34, height: 28)
            imageViewUser1.layer.borderWidth = 1
            imageViewUser1.layer.masksToBounds = false
            imageViewUser1.layer.borderColor = UIColor.white.cgColor
            imageViewUser1.layer.cornerRadius = imageViewUser1.frame.height/2
            imageViewUser1.clipsToBounds = true
            
            let username = UILabel(frame: CGRect(x: 70, y:20, width:100, height:30))
            username.text = "Adam sandler"
            username.font = UIFont(name: "Bariol-Bold", size: 14)
            
            let imageVs = UIImageView(image:UIImage(named:"star"))
            imageVs.frame = CGRect(x:70, y:55, width:10, height:10)
            
            let rating = UILabel(frame: CGRect(x: 90, y: 45, width:25, height: 25))
            rating.text = "4.2"
            rating.font = UIFont(name: "Bariol-Regular", size: 13)
            rating.textColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
            
            let reviewText = UILabel(frame: CGRect(x: 20, y: 100, width:Int(view.frame.size.width) - 140, height: 80))
            reviewText.numberOfLines = 10
            reviewText.text = "I had only heard of Fattoush until now and recently dined here for a \nbloggers meet along with a few foodie friends.\n\nThis place serves both Buffet and Ala Carte,so my review is based on \nthe Ala Carte experience ONLY. \n\nThe decor is nice and beautiful with two dining sections. I didnt know it was actually a pretty spacious place and easily accommodate a big crowd! \nTheres also a tiny children's play area which was very pleasing to see. So its a kids friendly place."
            reviewText.font = UIFont(name: "Bariol-Regular", size: 13)
            reviewText.textColor = UIColor.gray
            
            newview.addSubview(imageViewUser1)
            newview.addSubview(username)
            newview.addSubview(imageVs)
            newview.addSubview(rating)
            newview.addSubview(reviewText)
        }
        
        return newview
    }
    
    func newFunc() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- MapViewDelegate methods
    func showRouteOnMap() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: annotations[0].coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotations[1].coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate (completionHandler: {
            (response: MKDirectionsResponse?, error: Error?) in
            
            if error == nil {
                let directionsResponse = response!
                let route = directionsResponse.routes[0] 
                self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            } else {
//                println(error)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.yellow
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    func getMapAnnotations() -> [RestrauUserCoordinate] {
        var annotations:Array = [RestrauUserCoordinate]()
        
        //load plist file
//        let path = Bundle.main.path(forResource: "restaurants", ofType: "plist")
//        let url = URL(fileURLWithPath: path!)
//        let data = try! Data(contentsOf: url)
//        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
//        //iterate and create annotations
//        let dictArray = plist as! [[String:AnyObject]]
        
        let lat = 12.921407
        let long = 77.633375
        let annotation = RestrauUserCoordinate(latitude: lat , longitude: long)
        annotation.title = "restaurant-name"
        
        let lat1 = 12.919137
        let long1 = 77.638106
        let annotation1 = RestrauUserCoordinate(latitude: lat1, longitude: long1)
        annotation1.title = "user-name"
        annotations.append(annotation)
        annotations.append(annotation1)
        
        return annotations
    }
    
    func zoomToRegion(lat:Double, longFor long:Double) {
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 700.0, 900.0)
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        let pinImage = UIImage(named: "markup")
        let size = CGSize(width: 18, height: 22)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let resizedPinImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let userImage = UIImage(named: "usermarkup")
        UIGraphicsBeginImageContext(size)
        userImage!.draw(in: CGRect(x:0, y:0, width:size.width - 10, height:size.height - 12))
        let resizedUserImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if annotation.title! as String! == "user-name" {
            annotationView?.image = resizedUserImage
        }else {
          annotationView?.image = resizedPinImage
        }
        return annotationView
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//        let annotation1 = RestrauUserCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        annotation1.title = "user-name"
//        annotations[1] = annotation1
//        
//        zoomToRegion(lat: location.coordinate.latitude, longFor:location.coordinate.longitude)
//    }
    
}
