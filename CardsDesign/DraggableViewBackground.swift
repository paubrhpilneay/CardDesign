//
//  DraggableViewBackground.swift
    //Eutierria
    //Created by Abhinay Varma
//

import Foundation
import UIKit
import CoreLocation
import Firebase

class DraggableViewBackground: UIView, DraggableViewDelegate, CLLocationManagerDelegate {
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!

    let MAX_BUFFER_SIZE = 2
    var CARD_HEIGHT: CGFloat = 386
    var CARD_WIDTH: CGFloat = 270

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    var undoButton: UIButton!
    var beenthereButton: UIButton!
    
    var fituLabel: UILabel!
    var restaurants = [RestaurantModel]()
    var amenityLabelsArray:[String]! = ["","","",""]
    var storageRef: FIRStorageReference!
    var currentLocation = CLLocation()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        CARD_WIDTH = self.frame.size.width - 50
        CARD_HEIGHT = self.frame.size.height - 182
        self.setupView()
        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        let locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
    }
    
    
    //this is the function which is creating draggable view and putting at max 2 cards on screen only
    func loadCards() -> Void {
        if restaurants.count > 0 {
            let numLoadedCardsCap = restaurants.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : restaurants.count
            for i in 0 ..< restaurants.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    //in this we are creating draggable view and customising them according to the server data and it conforns to dragableview delegate
    func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 24, width: CARD_WIDTH, height: CARD_HEIGHT))
        
        
        // this is the place to configure all the detail of a new card so we will be updating server data here
        draggableView.restrauName.text = restaurants[index].name
        draggableView.cuisines.text = restaurants[index].cuisines
        let url = URL(string: self.restaurants[index].mainImage)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            DispatchQueue.main.async {
                if data != nil {  //Some time Data value will be nil so we need to validate such things
                    draggableView.restrauImage.image = UIImage(data: data! as Data,scale:1.0)
                }
            }
        }
        task.resume()
        draggableView.restrauImage.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector(ratingButtonTapped)))
        draggableView.restrauImage.isUserInteractionEnabled = true
        for index in 0...2 {
            let cost = restaurants[index].cost
            if index > cost {
                draggableView.imagePrice[index].image = UIImage(named:"dollar_green")
            } else {
                draggableView.imagePrice[index].image = UIImage(named:"dollar_green")
            }
        }
        
        draggableView.ratingLabel.text = String(restaurants[index].rating)
        updateAmenities(draggableView, index)
        draggableView.delegate = self
        return draggableView
    }
    
    
    
    //loadCard is called from restaurant feed using draggableviewbackground instance
    //setting up cards + other part of card screen
    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        
        //Restaurant that fits you label at top
        fituLabel = UILabel(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH) / 2 + self.frame.width/64, y: (self.frame.size.height*32) / 568, width: (self.frame.width * 5) / 8, height: (self.frame.size.height * 5) / 142))
        fituLabel.text = "Restaurants to fit you"
        fituLabel.textAlignment = NSTextAlignment.left
        fituLabel.textColor = UIColor.lightGray
        fituLabel.font = fituLabel.font.withSize(13)
        
        undoButton = UIButton(frame: CGRect(x: (self.center.x) - 140, y: self.frame.size.height/2 + CARD_HEIGHT/2, width: 80, height:80))
        undoButton.setImage(UIImage(named: "undo"), for: UIControlState())
        undoButton.addTarget(self, action: #selector(DraggableViewBackground.swipeTop), for: UIControlEvents.touchUpInside)
        
        xButton = UIButton(frame: CGRect(x: (self.center.x) - 85 , y: self.frame.size.height/2 + CARD_HEIGHT/2 - (self.frame.size.height*3)/71, width: 100, height: 100))
        xButton.setImage(UIImage(named: "xButton"), for: UIControlState())
        xButton.addTarget(self, action: #selector(DraggableViewBackground.swipeLeft), for: UIControlEvents.touchUpInside)

        checkButton = UIButton(frame: CGRect(x: (self.center.x) - 5, y: self.frame.size.height/2 + CARD_HEIGHT/2 - (self.frame.size.height*3)/71, width: 100, height: 100))
        checkButton.setImage(UIImage(named: "checkButton"), for: UIControlState())
        checkButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)
        
        beenthereButton = UIButton(frame: CGRect(x: (self.center.x) + 65, y: self.frame.size.height/2 + CARD_HEIGHT/2 , width: 80, height: 80))
        beenthereButton.setImage(UIImage(named: "beenthere"), for: UIControlState())
        beenthereButton.addTarget(self, action: #selector(DraggableViewBackground.swipeTop), for: UIControlEvents.touchUpInside)
        
        undoButton.center.y = xButton.center.y
        beenthereButton.center.y = xButton.center.y
        
        self.addSubview(fituLabel)
        self.addSubview(xButton)
        self.addSubview(checkButton)
        self.addSubview(undoButton)
        self.addSubview(beenthereButton)
    }
    
    //updating amenities icons based on the amenity puting image + text
    //add more cases to extend amenities
    func updateAmenities(_ dView: DraggableView,_ restrauIndex: NSInteger) {
        var ammenityKeys:Array = (restaurants[0].amenities as NSDictionary?)?.allKeys as! [String]
        for index in 0...ammenityKeys.count - 1  {
            switch(ammenityKeys[index]) {
            case "time"  : dView.imageViewAmenities[index].image = UIImage(named:"yellowclock.png")
                           let date = NSDate()
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateStyle = .full
                           var day = (dateFormatter.string(from: date as Date)).components(separatedBy: ",")[0]
                           if day == "Saturday" {
                                day = "saturday"
                           } else if day == "Sunday" {
                                day = "sunday"
                           } else {
                                day = "monday-friday"
                           }
                           let dayOpenCloseTime = (((restaurants[restrauIndex].amenities as NSDictionary?)?[ammenityKeys[index]] as! NSDictionary?))?[day] as! String
                           let calendar = NSCalendar.current
                           let hour = calendar.component(.hour, from: date as Date)
                           if dayOpenCloseTime == "closed" {
                             amenityLabelsArray[index] = "closed"
                             dView.amenitiesLabels[index].text = "closed"
                           } else {
                             amenityLabelsArray[index] = openingClosingTime(hour,dayOpenCloseTime)
                             dView.amenitiesLabels[index].text = amenityLabelsArray[index]
                           }
                           break
            case "location" : dView.imageViewAmenities[index].image = UIImage(named:"map_icon")
                              amenityLabelsArray[index] = calculateDistance((restaurants[restrauIndex].amenities as NSDictionary?)?["location"] as! String)+" m"
                              dView.amenitiesLabels[index].text = amenityLabelsArray[index]
                              break
            case "wifi" : dView.imageViewAmenities[index].image = UIImage(named:"wifi_icon")
                          let value = (restaurants[restrauIndex].amenities as NSDictionary?)?[ammenityKeys[index]] as! String
                          if value == "yes" {
                            amenityLabelsArray[index] = "Wifi"
                            dView.amenitiesLabels[index].text = "Wifi"
                          }
                          else {
                            amenityLabelsArray[index] = "No Wifi"
                            dView.amenitiesLabels[index].text = "No Wifi"
                          }
                          break
            case "delivery" : dView.imageViewAmenities[index].image = UIImage(named:"food-delivery")
                         let value = (restaurants[restrauIndex].amenities as NSDictionary?)?[ammenityKeys[index]] as! String
                         if value == "yes" {
                            amenityLabelsArray[index] = "Delivery"
                            dView.amenitiesLabels[index].text = "Delivery"
                         }
                         else {
                            amenityLabelsArray[index] = "Delivery Unavailable"
                            dView.amenitiesLabels[index].text = "Delivery Unavailable"
                        }
                        break
            default : break
                
            }
        }
    }
    
    //calculating ths open/close quote for screen according to the time nearest to open/close time
    func openingClosingTime(_ currentTime:Int, _ openCloseTime:String) -> String {
        let openTime = openCloseTime.components(separatedBy: "-")[0]
        let closeTime = openCloseTime.components(separatedBy: "-")[1]
        var open = Int()
        var close = Int()
        if openTime.lowercased().range(of: "p") != nil {
            open = Int(openTime.replacingOccurrences(of: "PM", with: ""))! + 12
        }else {
            open = Int(openTime.replacingOccurrences(of: "AM", with: ""))!
        }
        if closeTime.lowercased().range(of: "p") != nil {
            close = Int(closeTime.replacingOccurrences(of: "PM", with: ""))! + 12
        }else {
            close = Int(closeTime.replacingOccurrences(of: "AM", with: ""))!
        }
        if currentTime - open > 0 && close - currentTime > 0 {
            return "upto \(closeTime)"
        }
        return "opens at \(openTime)"
    }
    
    //calculating distance between location and the current location in meters
    func calculateDistance(_ location:String) -> String {
        let lat = Double(location.components(separatedBy: ",")[0])
        let long = Double(location.components(separatedBy: ",")[1])
        let restaurantLocation = CLLocation(latitude: lat!, longitude: long!)
        return String(currentLocation.distance(from: restaurantLocation))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
         manager.stopUpdatingLocation()
        currentLocation = userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //when image is tapped for displaying detailed controller of restaurant card
    func ratingButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetail
        vc.restrau = self.restaurants[cardsLoadedIndex-2]
        vc.amenityLblArr = amenityLabelsArray
        MyUtility.firstAvailableUIViewController(fromResponder:self)?.navigationController?.pushViewController(vc,animated: true)
    }
    
    
    
    func cardSwipedLeft(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)

        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        } else if loadedCards.count == 0 {
            cardOver()
        }
    }
    
    func cardSwipedRight(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }else if loadedCards.count == 0 {
            cardOver()
        }
    }

    func cardSwipedTop(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        } else if loadedCards.count == 0 {
            cardOver()
        }
    }
    
    // when like button is pressed
    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        
        dragView.overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeRight)
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    //when unlike button is pressed
    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.frame = CGRect(x:self.frame.size.width - 150, y:10, width:130, height:120)
        dragView.overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeLeft)
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
    
    func swipeTop() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        
        dragView.overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeTop)
        UIView.animate(withDuration: 0.3, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.topClickAction()
    }
    
    func cardOver() {
        let newview = UIView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 24, width: CARD_WIDTH, height: CARD_HEIGHT))
        newview.backgroundColor = UIColor.white
        let label = UILabel(frame:CGRect(x:40, y:50, width:250, height:30))
        label.text = "Please Reload The Page"
        let refresh = UIImageView(image:UIImage(named:"reload"))
        refresh.frame = CGRect(x:30, y:80, width:50, height: 50)
        refresh.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector(refreshTapped)))
        refresh.isUserInteractionEnabled = true
        newview.addSubview(refresh)
        newview.addSubview(label)
        newview.tag = 100
//        self.insertSubview(newview, belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        self.addSubview(newview)
    }
    
    func refreshTapped() {
        self.viewWithTag(100)?.removeFromSuperview()
        cardsLoadedIndex = 0
        allCards = []
        if restaurants.count > 0 {
            let numLoadedCardsCap = restaurants.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : restaurants.count
            for i in 0 ..< restaurants.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }

}
