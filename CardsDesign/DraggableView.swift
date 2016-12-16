//
//  DraggableView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(_ card: UIView) -> Void
    func cardSwipedRight(_ card: UIView) -> Void
}

class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var xFromCenter: Float!
    var yFromCenter: Float!
    var restrauName: UILabel!
    var cuisines: UILabel!
    var ocTime: UILabel!
    var locationTime: UILabel!
    var wifi: UILabel!
    var delivery: UILabel!
    var ratingLabel: UILabel!
    var restrauImage: UIImageView!
    var rating: String!
    var friendImage: [String] = ["user1.png","user2.png","user3.png"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
        self.backgroundColor = UIColor.white

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))

        self.addGestureRecognizer(panGestureRecognizer)

        overlayView = OverlayView(frame: CGRect(x: self.frame.size.width/2-100, y: 0, width: 100, height: 100))
        overlayView.alpha = 0
        self.addSubview(overlayView)

        xFromCenter = 0
        yFromCenter = 0
    }

    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize(width: 1, height: 1);
        
        //setting up restrau name
        restrauName = UILabel(frame: CGRect(x: 15, y: 10, width:160, height: 40))
        restrauName.text = "Smoke House Deli"
        
        restrauName.textColor = UIColor.black
        let fontSize = restrauName.font.pointSize
        restrauName.font = UIFont(name: "Georgia-Bold", size: fontSize-2)
        
        
        //setting up cuisines
        cuisines = UILabel(frame: CGRect(x: 15, y: 40, width:130, height: 20))
        cuisines.text = "Europian,Italian"
        cuisines.textColor = UIColor.gray
        let cuisineSize = cuisines.font.pointSize
        cuisines.font = UIFont(name: "STHeitiK-Light", size: cuisineSize-9)
        cuisines.font = cuisines.font.withSize(10)
        
        
        //green and grey dollars
        let imageGreen = "dollar_green.png"
        let imageGray = "dollar_grey.png"
        let imageGn = UIImage(named: imageGreen)
        let imageGy = UIImage(named: imageGray)
        let imageView1 = UIImageView(image: imageGn!)
        let imageView2 = UIImageView(image: imageGn!)
        let imageView3 = UIImageView(image: imageGy!)
        imageView1.frame = CGRect(x: 230, y: 25, width: 7, height: 13)
        imageView2.frame = CGRect(x: 245, y: 25, width: 7, height: 13)
        imageView3.frame = CGRect(x: 260, y: 25, width: 7, height: 13)
        
        
        //4 icons
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
        
        imageViewClock.frame = CGRect(x: 30, y: 75, width: 14, height: 14)
        imageViewLocation.frame = CGRect(x: 100, y: 75, width: 12, height: 16)
        imageViewWifi.frame = CGRect(x: 170, y: 75, width: 17, height: 12)
        imageViewDelivery.frame = CGRect(x: 240, y: 75, width: 14, height: 14)
        
        
        
        //labels for the 4 icons
        ocTime = UILabel(frame: CGRect(x: 18, y: 85, width:60, height: 40))
        ocTime.text = "upto 11 PM"
        ocTime.textColor = UIColor.lightGray
        ocTime.font = cuisines.font.withSize(8)
        
        locationTime = UILabel(frame: CGRect(x: 100, y: 85, width:40, height: 40))
        locationTime.text = "2.5 m"
        locationTime.textColor = UIColor.lightGray
        locationTime.font = cuisines.font.withSize(8)
        
        
        wifi = UILabel(frame: CGRect(x: 170, y: 85, width:40, height: 40))
        wifi.text = "Wifi"
        wifi.textColor = UIColor.lightGray
        wifi.font = cuisines.font.withSize(8)
        
        
        delivery = UILabel(frame: CGRect(x: 235, y: 85, width:40, height: 40))
        delivery.text = "Delivery"
        delivery.textColor = UIColor.lightGray
        delivery.font = cuisines.font.withSize(8)
        
        
        //imageview for restaurant image
        let imageRestaurant = "restaurant-1.jpg"
        let imageRestrau = UIImage(named: imageRestaurant)
        let imageViewRestaurant = UIImageView(image: imageRestrau)
        
        imageViewRestaurant.frame = CGRect(x: 18, y: 127, width: 255, height: 220)
        
        
        //adding text to image
        let imageRating = "greenRect.png"
        let imageRtng = UIImage(named: imageRating)
        self.rating = "4.2"
        let imageViewRating = UIImageView(image: imageRtng)
        imageViewRating.frame = CGRect(x: 210, y: 10, width: 35, height: 25)
        ratingLabel = UILabel(frame: CGRect(x: 10, y: 3, width: 20, height: 20))
        ratingLabel.text = rating
        ratingLabel.textColor = UIColor.white
        ratingLabel.font = cuisines.font.withSize(12)
        imageViewRating.addSubview(ratingLabel)
        imageViewRestaurant.addSubview(imageViewRating)
        
//        var friendsImages: [UIImageView]?
//        var userImage: UIImage!
//        //adding 3 circular friends image along with +n count
//        for index in 0...2 {
//            userImage = UIImage(named: friendImage[index])
//            friendsImages[index] = UIImageView(image: userImage)
//            friendsImages[index].layer.borderWidth = 1
//            friendsImages[index].layer.masksToBounds = false
//            friendsImages[index].layer.borderColor = UIColor.black.cgColor
//            friendsImages[index].layer.cornerRadius = friendsImages[index].frame.height/2
//            friendsImages[index].clipsToBounds = true
//            friendsImages[index].frame = CGRect(x: 20 + index*5, y: 360, width: 10, height: 16)
//            self.addSubview(friendsImages[index])
//        }
        
        //adding 3 circular friends image along with +n count
        
        
        let imageUser1 = "user1.png"
        let imageUsr1 = UIImage(named: imageUser1)
        let imageViewUser1 = UIImageView(image: imageUsr1)
        imageViewUser1.frame = CGRect(x: 15, y: 360, width: 18, height: 15)
        imageViewUser1.layer.borderWidth = 1
        imageViewUser1.layer.masksToBounds = false
        imageViewUser1.layer.borderColor = UIColor.white.cgColor
        imageViewUser1.layer.cornerRadius = imageViewUser1.frame.height/2
        imageViewUser1.clipsToBounds = true
        
        let imageUser2 = "user2.jpeg"
        let imageUsr2 = UIImage(named: imageUser2)
        let imageViewUser2 = UIImageView(image: imageUsr2)
        imageViewUser2.frame = CGRect(x: 35, y: 360, width: 18, height: 15)
        imageViewUser2.layer.borderWidth = 1
        imageViewUser2.layer.masksToBounds = false
        imageViewUser2.layer.borderColor = UIColor.white.cgColor
        imageViewUser2.layer.cornerRadius = imageViewUser2.frame.height/2
        imageViewUser2.clipsToBounds = true
        
        let imageUser3 = "user3.png"
        let imageUsr3 = UIImage(named: imageUser3)
        let imageViewUser3 = UIImageView(image: imageUsr3)
        imageViewUser3.frame = CGRect(x: 55, y: 360, width: 18, height: 15)
        imageViewUser3.layer.borderWidth = 1
        imageViewUser3.layer.masksToBounds = false
        imageViewUser3.layer.borderColor = UIColor.white.cgColor
        imageViewUser3.layer.cornerRadius = imageViewUser3.frame.height/2
        imageViewUser3.clipsToBounds = true
        
        
        let addCount = UILabel(frame: CGRect(x: 75, y: 345, width:60, height: 40))
        addCount.text = "+17 friends"
        addCount.textColor = UIColor.darkGray
        addCount.font = cuisines.font.withSize(10)
        
        
        self.addSubview(imageView1)
        self.addSubview(imageView2)
        self.addSubview(imageView3)
        self.addSubview(restrauName)
        self.addSubview(cuisines)
        self.addSubview(imageViewClock)
        self.addSubview(imageViewLocation)
        self.addSubview(imageViewWifi)
        self.addSubview(imageViewDelivery)
        self.addSubview(ocTime)
        self.addSubview(locationTime)
        self.addSubview(wifi)
        self.addSubview(delivery)
        self.addSubview(imageViewRestaurant)
        self.addSubview(imageViewUser1)
        self.addSubview(imageViewUser2)
        self.addSubview(imageViewUser3)
        self.addSubview(addCount)
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 40)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
        case UIGestureRecognizerState.changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

            self.center = CGPoint(x: self.originPoint.x + CGFloat(xFromCenter), y: self.originPoint.y + CGFloat(yFromCenter))

            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            let scaleTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(CGFloat(xFromCenter))
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.possible:
            fallthrough
        case UIGestureRecognizerState.cancelled:
            fallthrough
        case UIGestureRecognizerState.failed:
            fallthrough
        default:
            break
        }
    }

    func updateOverlay(_ distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeRight)
        } else {
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.4))
    }

    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }

    func rightClickAction() -> Void {
        let finishPoint = CGPoint(x: 600, y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }

    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -600, y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
}
