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
    func cardSwipedTop(_ card: UIView) -> Void
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

    var ratingLabel: UILabel!
    var restrauImage: UIImageView!
    var rating: String!
    var friendImage: [String] = ["user1.png","user2.png","user3.png"]
    var imageButton: UIButton!
    var imageViewAmenities: [UIImageView]! = [UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    var amenitiesLabels: [UILabel]! = [UILabel(),UILabel(),UILabel(),UILabel()]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
        self.backgroundColor = UIColor.white
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))
        
        self.addGestureRecognizer(panGestureRecognizer)
        
        overlayView = OverlayView(frame: CGRect(x: 5, y: 20, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*80)/386))
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        xFromCenter = 0
        yFromCenter = 0
    }
    
    func setupView() -> Void {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        //setting up restrau name
        restrauName = UILabel(frame: CGRect(x: self.frame.size.width/18, y: (self.frame.size.height*5)/193, width:(self.frame.size.width*16)/27, height: (self.frame.size.height*20)/193))
        restrauName.text = "Smoke House Deli"
        
        restrauName.textColor = UIColor.black
        let fontSize = restrauName.font.pointSize
        restrauName.font = UIFont(name: "Bariol-Bold", size: fontSize)
        
        //setting up cuisines
        cuisines = UILabel(frame: CGRect(x: self.frame.size.width/18, y: (self.frame.size.height*20)/193, width:(self.frame.size.width*13)/27, height: (self.frame.size.height*10)/193))
        cuisines.text = "Europian,Italian"
        cuisines.font = UIFont(name: "Bariol-Regular", size: 10)
        cuisines.font = cuisines.font.withSize(12)
        cuisines.textColor = UIColor.darkGray
        
        //green and grey dollars
        let imageGreen = "dollar_green.png"
        let imageGray = "dollar_grey.png"
        let imageGn = UIImage(named: imageGreen)
        let imageGy = UIImage(named: imageGray)
        let imageView1 = UIImageView(image: imageGn!)
        let imageView2 = UIImageView(image: imageGn!)
        let imageView3 = UIImageView(image: imageGy!)
        imageView1.frame = CGRect(x: (self.frame.size.width*215)/270, y: (self.frame.size.height*25)/386, width: (self.frame.size.width*7)/270, height: (self.frame.size.height*13)/386)
        imageView2.frame = CGRect(x: (self.frame.size.width*23)/27, y: (self.frame.size.height*25)/386, width: (self.frame.size.width*7)/270, height: (self.frame.size.height*13)/386)
        imageView3.frame = CGRect(x: (self.frame.size.width*245)/270, y: (self.frame.size.height*25)/386, width: (self.frame.size.width*7)/270, height: (self.frame.size.height*13)/386)
        
       
        //4 icons
        let imageClock = "yellowclock.png"
        let imageClk = UIImage(named: imageClock)
        imageViewAmenities[0] = UIImageView(image: imageClk)
        
        let imageMap = "map_icon.png"
        let imageMp = UIImage(named: imageMap)
        imageViewAmenities[1] = UIImageView(image: imageMp)
        
        let imageWifi = "wifi_icon.png"
        let imageWf = UIImage(named: imageWifi)
        imageViewAmenities[2] = UIImageView(image: imageWf)
        
        let imageDelivery = "food-delivery.png"
        let imageDlvry = UIImage(named: imageDelivery)
        imageViewAmenities[3] = UIImageView(image: imageDlvry)
        
        imageViewAmenities[0].frame = CGRect(x: (self.frame.size.width)/9, y: (self.frame.size.height*75)/386, width: 20, height: 20)
        imageViewAmenities[1].frame = CGRect(x: (self.frame.size.width*95)/270, y: (self.frame.size.height*73)/386, width: 20, height: 20)
        imageViewAmenities[2].frame = CGRect(x: (self.frame.size.width*16)/27, y: (self.frame.size.height*75)/386, width: 20, height: 20)
        imageViewAmenities[3].frame = CGRect(x: (self.frame.size.width*225)/270, y: (self.frame.size.height*73)/386, width: 20, height: 20)
        
        
        
        //labels for the 4 icons
        amenitiesLabels[0] = UILabel(frame: CGRect(x: (self.frame.size.width*18)/270, y: (self.frame.size.height*85)/386, width:(self.frame.size.width*60)/270, height: (self.frame.size.height*40)/386))
        amenitiesLabels[0].textAlignment = .center
        amenitiesLabels[0].center.x = imageViewAmenities[0].center.x
        amenitiesLabels[0].text = "upto 11 PM"
        amenitiesLabels[0].textColor = UIColor.darkGray
        amenitiesLabels[0].font = UIFont(name: "Bariol-Regular", size: 10)
        
        amenitiesLabels[1] = UILabel(frame: CGRect(x: (self.frame.size.width)/3, y: (self.frame.size.height*85)/386, width:(self.frame.size.width*4)/27, height: (self.frame.size.height*40)/386))
        amenitiesLabels[1].textAlignment = .center
        amenitiesLabels[1].center.x = imageViewAmenities[1].center.x
        amenitiesLabels[1].text = "2.5 m"
        amenitiesLabels[1].textColor = UIColor.darkGray
        amenitiesLabels[1].font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        amenitiesLabels[2] = UILabel(frame: CGRect(x: (self.frame.size.width*16)/27, y: (self.frame.size.height*85)/386, width:(self.frame.size.width*4)/27, height: (self.frame.size.height*40)/386))
        amenitiesLabels[2].textAlignment = .center
        amenitiesLabels[2].center.x = imageViewAmenities[2].center.x
        amenitiesLabels[2].text = "Wifi"
        amenitiesLabels[2].textColor = UIColor.darkGray
        amenitiesLabels[2].font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        amenitiesLabels[3] = UILabel(frame: CGRect(x: (self.frame.size.width*217)/270, y: (self.frame.size.height*85)/386, width:(self.frame.size.width*40)/270, height: (self.frame.size.height*40)/386))
        amenitiesLabels[3].textAlignment = .center
        amenitiesLabels[3].center.x = imageViewAmenities[3].center.x
        amenitiesLabels[3].text = "Delivery"
        amenitiesLabels[3].textColor = UIColor.darkGray
        amenitiesLabels[3].font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        //imageview for restaurant image
        let imageRestaurant = "restaurant-1.jpg"
        let imageRestrau = UIImage(named: imageRestaurant)
        restrauImage = UIImageView(image: imageRestrau)
        
        restrauImage.frame = CGRect(x: self.frame.size.width/15, y: (self.frame.size.height*127)/386, width: self.frame.size.width - (self.frame.size.width*7)/54, height: self.frame.size.height - (self.frame.size.height*83)/193)
        imageButton = UIButton(frame: CGRect(x: self.frame.size.width/15, y: (self.frame.size.height*127)/386, width: self.frame.size.width - (self.frame.size.width*7)/54, height: self.frame.size.height - (self.frame.size.height*83)/193))
        self.insertSubview(imageButton, belowSubview: restrauImage)
        
        //adding text to image
        let imageRating = "greenRect.png"
        let imageRtng = UIImage(named: imageRating)
        self.rating = "4.2"
        let imageViewRating = UIImageView(image: imageRtng)
        imageViewRating.frame = CGRect(x: (self.frame.size.width*2)/3, y: (self.frame.size.height*10)/386, width: (self.frame.size.width*4)/27, height: (self.frame.size.height*30)/386)
        ratingLabel = UILabel(frame: CGRect(x: (self.frame.size.width)/27, y: (self.frame.size.height*3)/386, width: (self.frame.size.width*25)/270, height: (self.frame.size.height*25)/386))
        ratingLabel.text = rating
        ratingLabel.textColor = UIColor.white
        ratingLabel.font = cuisines.font.withSize(13)
        imageViewRating.addSubview(ratingLabel)
        restrauImage.addSubview(imageViewRating)
        
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
        imageViewUser1.frame = CGRect(x: (self.frame.size.width*2)/27, y: (self.frame.size.height*360)/386, width: (self.frame.size.width*2)/27, height: (self.frame.size.height*18)/386)
        imageViewUser1.layer.borderWidth = 1
        imageViewUser1.layer.masksToBounds = false
        imageViewUser1.layer.borderColor = UIColor.white.cgColor
        imageViewUser1.layer.cornerRadius = imageViewUser1.frame.height/2
        imageViewUser1.clipsToBounds = true
        
        let imageUser2 = "user1.jpeg"
        let imageUsr2 = UIImage(named: imageUser2)
        let imageViewUser2 = UIImageView(image: imageUsr2)
        imageViewUser2.frame = CGRect(x: (self.frame.size.width*4)/27, y: (self.frame.size.height*360)/386, width: (self.frame.size.width*2)/27, height: (self.frame.size.height*18)/386)
        imageViewUser2.layer.borderWidth = 1
        imageViewUser2.layer.masksToBounds = false
        imageViewUser2.layer.borderColor = UIColor.white.cgColor
        imageViewUser2.layer.cornerRadius = imageViewUser2.frame.height/2
        imageViewUser2.clipsToBounds = true
        
        let imageUser3 = "user3.png"
        let imageUsr3 = UIImage(named: imageUser3)
        let imageViewUser3 = UIImageView(image: imageUsr3)
        imageViewUser3.frame = CGRect(x: (self.frame.size.width*2)/9, y: (self.frame.size.height*360)/386, width: (self.frame.size.width*2)/27, height: (self.frame.size.height*18)/386)
        imageViewUser3.layer.borderWidth = 1
        imageViewUser3.layer.masksToBounds = false
        imageViewUser3.layer.borderColor = UIColor.white.cgColor
        imageViewUser3.layer.cornerRadius = imageViewUser3.frame.height/2
        imageViewUser3.clipsToBounds = true
        
        
        let addCount = UILabel(frame: CGRect(x: (self.frame.size.width*85)/270, y: (self.frame.size.height*350)/386, width:(self.frame.size.width*2)/9, height: (self.frame.size.height*40)/386))
        addCount.text = "+17 friends"
        addCount.textColor = UIColor.darkGray
        addCount.font = UIFont(name: "Bariol-Thin", size: 10)
        
        self.addSubview(imageView1)
        self.addSubview(imageView2)
        self.addSubview(imageView3)
        self.addSubview(restrauName)
        self.addSubview(cuisines)
        self.addSubview(imageViewAmenities[0])
        self.addSubview(imageViewAmenities[1])
        self.addSubview(imageViewAmenities[2])
        self.addSubview(imageViewAmenities[3])
        self.addSubview(amenitiesLabels[0])
        self.addSubview(amenitiesLabels[1])
        self.addSubview(amenitiesLabels[2])
        self.addSubview(amenitiesLabels[3])
        self.addSubview(restrauImage)
        self.addSubview(imageViewUser1)
        self.addSubview(imageViewUser2)
        self.addSubview(imageViewUser3)
        self.addSubview(addCount)
        
    }
    
    
    //to write label on image
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
            self.updateOverlay(CGFloat(xFromCenter),CGFloat(yFromCenter))
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
    
    func updateOverlay(_ distance: CGFloat, _ ydist: CGFloat) -> Void {
        
        if ydist < 0 && distance > -10 && distance < 10{
            overlayView.frame = CGRect(x:5, y:15, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*80)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeTop)
            overlayView.alpha = CGFloat(min(fabsf(Float(ydist))/100 + 0.2, 0.7))
        }else if distance > 0 {
            overlayView.frame = CGRect(x:5, y:15, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*80)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeRight)
            overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100 + 0.2, 0.9))
        } else {
            overlayView.frame = CGRect(x:self.frame.size.width-(self.frame.size.width*10)/27, y:5, width: (self.frame.size.width*10)/27, height: (self.frame.size.height*160)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeLeft)
            overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100 + 0.2, 0.9))
        }
        
    }
    
    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        let floatYFromCenter = Float(yFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else if floatYFromCenter < ACTION_MARGIN && (floatXFromCenter > 40 || floatXFromCenter < -40) {
            self.topAction()
        }else {
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
    
    func topAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.center = finishPoint
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        delegate.cardSwipedTop(self)
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
