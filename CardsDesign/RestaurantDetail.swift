//
//  RestaurantDetail.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 17/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//
import UIKit
import MapKit

class RestaurantDetail: UIViewController, UIScrollViewDelegate, HorizontaScrollDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
   
    var scrollView: UIScrollView!
    var containerView = UIView()
    var restrau:RestaurantModel!
    var amenityLblArr:[String]!
    var imageArr : [String] = ["deli2","deli3","deli4"]
    var menu : [String] = ["menu1","menu2","menu2","menu1","menu2","menu1","menu2","menu1"]
    var delegateCount:Int = 0
    let mapView: MKMapView! = MKMapView()
    var annotations:[RestrauUserCoordinate]!
    var locationManager: CLLocationManager!
    var imageViewAmmenity:[UIImageView]! = [UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        let buttonOne: UIButton = UIButton(frame:CGRect(x:20, y:30, width:40, height:40))
        buttonOne.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        buttonOne.addTarget(self, action: #selector(newFunc), for: UIControlEvents.touchUpInside)
        
        
        let hScroll = HorizontalScroll(frame:CGRect(x:0, y:0, width: view.frame.width, height:150))
        hScroll.backgroundColor = UIColor.gray
        hScroll.delegate = self

        let restaurantName = UILabel(frame: CGRect(x: 15, y: 163, width:160, height: 40))
        restaurantName.text = restrau.name
        restaurantName.font = UIFont(name: "Bariol-Regular", size: 18)
        restaurantName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let cuisines = UILabel(frame: CGRect(x: 15, y: 187, width:90, height: 30))
        cuisines.text = restrau.cuisines
        cuisines.font = UIFont(name: "Bariol-Light", size: 12)
        cuisines.textColor = UIColor.darkGray
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width:view.frame.width, height:1650)
        
        containerView = UIView()
    
        let imageUsr3 = UIImage(named: "stars")
        let imageViewStars = UIImageView(image: imageUsr3)
        imageViewStars.frame = CGRect(x: 15, y: 227, width: 120, height: 15)
        
        let rating = UILabel(frame: CGRect(x: 160, y: 220, width:25, height: 30))
        rating.text = String(restrau.rating)
        rating.font = UIFont(name: "Bariol-Regular", size: 15)
        rating.textColor = UIColor(red:0, green:0.6, blue:0, alpha:1)
        rating.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        let imageView:[UIImageView] = [UIImageView(),UIImageView(),UIImageView()]
        imageView[0].frame = CGRect(x: (view.frame.size.width*255)/320, y: 180, width: 10, height: 20)
        imageView[1].frame = CGRect(x: (view.frame.size.width*270)/320,y: 180, width: 10, height: 20)
        imageView[2].frame = CGRect(x: (view.frame.size.width*285)/320, y: 180, width: 10, height: 20)
        
        if restrau.cost == 3 {
            imageView[0].image = UIImage(named:"dollar_green")
            imageView[1].image = UIImage(named:"dollar_green")
            imageView[2].image = UIImage(named:"dollar_green")
        } else if restrau.cost == 2 {
            imageView[0].image = UIImage(named:"dollar_green")
            imageView[1].image = UIImage(named:"dollar_green")
            imageView[2].image = UIImage(named:"dollar_grey")
        } else if restrau.cost == 1 {
            imageView[0].image = UIImage(named:"dollar_grey")
            imageView[1].image = UIImage(named:"dollar_grey")
           imageView[2].image = UIImage(named:"dollar_green")
        } else {
            imageView[0].image = UIImage(named:"dollar_grey")
            imageView[1].image = UIImage(named:"dollar_grey")
            imageView[2].image = UIImage(named:"dollar_grey")
        }
        
        
        
        imageViewAmmenity[0] = UIImageView(frame: CGRect(x: view.frame.size.width/11, y: 270, width: 20, height: 20))
        
        imageViewAmmenity[1] = UIImageView(frame: CGRect(x: (view.frame.size.width*4)/11 - 15, y: 268, width: 20, height: 20))
        
        imageViewAmmenity[2] = UIImageView(frame: CGRect(x: (view.frame.size.width*7)/11 - 17, y: 270, width: 20, height: 20))
        
        imageViewAmmenity[3] = UIImageView(frame: CGRect(x: (view.frame.size.width*10)/11 - 13, y: 268, width: 20, height: 20))
        
        
        var ammenityKeys:Array = (restrau.amenities as NSDictionary?)?.allKeys as! [String]
        for index in 0...ammenityKeys.count - 1  {
            switch(ammenityKeys[index]) {
                case "time"  : imageViewAmmenity[index].image = UIImage(named:"yellowclock.png")
                                break
                case "location" : imageViewAmmenity[index].image = UIImage(named:"map_icon")
                              break
                case "wifi" : imageViewAmmenity[index].image = UIImage(named:"wifi_icon")
                            break
                case "delivery" : imageViewAmmenity[index].image = UIImage(named:"food-delivery")
                            break
                default : break
            }
        }

        
        let ocTime = UILabel(frame: CGRect(x: (view.frame.size.width/11) - 8, y: 281, width:60, height: 40))
        ocTime.text = amenityLblArr[0]
        ocTime.textColor = UIColor.gray
        ocTime.font = UIFont(name: "Bariol-Bold", size: 10)
        ocTime.textAlignment = .center
        
        let locationTime = UILabel(frame: CGRect(x: ((view.frame.size.width * 4)/11) - 8, y: 281, width:40, height: 40))
        locationTime.text = amenityLblArr[1]
        locationTime.textColor = UIColor.gray
        locationTime.font = UIFont(name: "Bariol-Bold", size: 10)
        locationTime.textAlignment = .center
        
        let wifi = UILabel(frame: CGRect(x: ((view.frame.size.width*7)/11) - 2, y: 281, width:40, height: 40))
        wifi.text = amenityLblArr[2]
        wifi.textColor = UIColor.gray
        wifi.font = UIFont(name: "Bariol-Bold", size: 10)
        wifi.textAlignment = .center
        
        let delivery = UILabel(frame: CGRect(x: ((view.frame.size.width*10)/11) - 12, y: 281, width:40, height: 40))
        delivery.text = amenityLblArr[3]
        delivery.textColor = UIColor.gray
        delivery.font = UIFont(name: "Bariol-Bold", size: 10)
        delivery.textAlignment = .center
        
        let topLabel = UILabel(frame:CGRect(x:20, y:330 , width:140, height:40))
        topLabel.text = "TOP THREE DISH"
        topLabel.textColor = UIColor(red: 0.5255, green: 0.5137, blue: 0.6588, alpha: 1.0)
        topLabel.font = UIFont(name: "Bariol-Regular", size: 14)
        
        
        ocTime.center.x = imageViewAmmenity[0].center.x
        locationTime.center.x = imageViewAmmenity[1].center.x
        wifi.center.x = imageViewAmmenity[2].center.x
        delivery.center.x = imageViewAmmenity[3].center.x
        
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
//        // Connect all the mappoints using Poly line.
//        
//        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//        
//        for annotation in annotations {
//            points.append(annotation.coordinate)
//        }
//        let polyline = MKPolyline(coordinates: points, count: points.count)
//        mapView.add(polyline)
//        showRouteOnMap()
        
        let addLabel = UILabel(frame:CGRect(x:20, y:510 + offset , width:250, height:40))
        addLabel.numberOfLines = 2
        addLabel.text = "128/54/10, Above A2B, Opposite IIM - B , Dasarapalya, \nBannerghatta Road , Bangalore"
        addLabel.textColor = UIColor.darkGray
        addLabel.font = UIFont(name: "Bariol-Regular", size: 10)
    
        
        let menuLabel = UILabel(frame:CGRect(x:20, y:550 + offset , width:50, height:40))
        menuLabel.text = "Menu"
        menuLabel.textColor = UIColor(red: 0.5255, green: 0.5137, blue: 0.6588, alpha: 1.0)
        menuLabel.font = UIFont(name: "Bariol-Regular", size: 14)
        
        let hMenuScroll = HorizontalScroll(frame:CGRect(x:15, y:595 + offset, width: Int(view.frame.size.width), height:80))
        hMenuScroll.backgroundColor = UIColor.white
        hMenuScroll.delegate = self
        
        let review = UILabel(frame:CGRect(x:25, y:690 + offset , width:130, height:40))
        review.text = "OFFICIAL REVIEW"
        review.textColor = UIColor(red: 0.5255, green: 0.5137, blue: 0.6588, alpha: 1.0)
        review.font = UIFont(name: "Bariol-Regular", size: 14)

        
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
        textView.font = UIFont(name: "Bariol-Regular", size: 11)
        
        
        let userreviews = UILabel(frame: CGRect(x: 23, y: 925 + offset, width:130, height: 40))
        userreviews.text = "USER REVIEWS"
        userreviews.textColor = UIColor(red: 0.5255, green: 0.5137, blue: 0.6588, alpha: 1.0)
        userreviews.font = UIFont(name: "Bariol-Regular", size: 14)
        
        
        let hReviewScroll = HorizontalScroll(frame:CGRect(x:23, y:970 + offset, width: Int(view.frame.size.width), height:250))
        hReviewScroll.backgroundColor = UIColor.white
        hReviewScroll.delegate = self
        
        
        let honorLabel:UILabel = UILabel(frame:CGRect(x:20, y:1220 + offset, width:80,height:40))
        honorLabel.text = "HONORS"
        honorLabel.textColor = UIColor(red: 0.5255, green: 0.5137, blue: 0.6588, alpha: 1.0)
        honorLabel.font = UIFont(name: "Bariol-Regular", size: 14)
        
        let imageHonors = ["honor1","honor2","honor3","honor4"]
        var newoffset:Int =  Int(view.frame.size.width)/16
        for index in 0 ... (imageHonors.count - 1) {
            let imageHonor = UIImage(named: imageHonors[index])
            let imageViewHonor = UIImageView(image: imageHonor)
            imageViewHonor.frame = CGRect(x: newoffset, y: 1260+offset, width: 60, height: 60)
            newoffset = newoffset + Int(view.frame.size.width)/4
            containerView.addSubview(imageViewHonor)
        }
        
        let reviewButton = UIImageView(frame: CGRect(x:Int((view.frame.size.width - 300)/2), y:1360 + offset, width:300, height:100))
        reviewButton.image = UIImage(named:"reviewRect")
        let label = UILabel(frame:CGRect(x:90, y:20, width:200, height:50))
        label.text = "Write your own review"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Bariol-Regular", size: 14)
        let penImage = UIImageView(image:UIImage(named:"pen"))
        penImage.frame = CGRect(x:66, y:40, width:10, height:10)
        reviewButton.addSubview(penImage)
        reviewButton.addSubview(label)
        
        
        let bgView = UIView(frame: CGRect(x: (self.view.center.x) - 160,y:self.view.frame.size.height - (self.view.frame.size.height*8)/71 - 10,width:315,height:110))
        bgView.backgroundColor = UIColor.white
        
        let undoButton = UIButton(frame: CGRect(x: (self.view.center.x) - 140, y: self.view.frame.size.height - 40, width: 80, height: 80))
        undoButton.setImage(UIImage(named: "undo"), for: UIControlState())
        undoButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)
        
        let xButton = UIButton(frame: CGRect(x: (self.view.center.x) - 85, y: self.view.frame.size.height - 80, width: 100, height: 100))
        xButton.setImage(UIImage(named: "xButton"), for: UIControlState())
        xButton.addTarget(self, action: #selector(DraggableViewBackground.swipeLeft), for: UIControlEvents.touchUpInside)
        
        let checkButton = UIButton(frame: CGRect(x:(self.view.center.x) - 5, y:self.view.frame.size.height - 80 , width: 100, height: 100))
        checkButton.setImage(UIImage(named: "checkButton"), for: UIControlState())
        checkButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)
        
        let beenthereButton = UIButton(frame: CGRect(x:(self.view.center.x) + 65, y: self.view.frame.size.height - 40 , width: 80, height: 80))
        beenthereButton.setImage(UIImage(named: "beenthere"), for: UIControlState())
        beenthereButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)
        
        beenthereButton.center.y = xButton.center.y
        undoButton.center.y = checkButton.center.y
        
        undoButton.alpha = 1
        xButton.alpha = 1
        checkButton.alpha = 1
        beenthereButton.alpha = 1
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(buttonOne)
        bgView.alpha = 0.4
        view.addSubview(bgView)
        view.addSubview(undoButton)
        view.addSubview(xButton)
        view.addSubview(checkButton)
        view.addSubview(beenthereButton)
        
        containerView.addSubview(restaurantName)
        containerView.addSubview(cuisines)
        containerView.addSubview(imageViewStars)
        containerView.addSubview(rating)
        containerView.addSubview(imageView[0])
        containerView.addSubview(imageView[1])
        containerView.addSubview(imageView[2])
        containerView.addSubview(imageViewAmmenity[0])
        containerView.addSubview(imageViewAmmenity[1])
        containerView.addSubview(imageViewAmmenity[2])
        containerView.addSubview(imageViewAmmenity[3])
        containerView.addSubview(ocTime)
        containerView.addSubview(locationTime)
        containerView.addSubview(wifi)
        containerView.addSubview(delivery)
        containerView.addSubview(hScroll)
        containerView.addSubview(imageViewStar)
        delegateCount += 1
        containerView.addSubview(hMenuScroll)
        delegateCount += 1
        
        containerView.addSubview(honorLabel)
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
    
    //configuring each scrollview n basis of delegate count
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
    
    func newFunc() {
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
}
