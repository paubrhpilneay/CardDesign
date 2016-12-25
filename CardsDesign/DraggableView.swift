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
    var imagePrice:[UIImageView]! = [UIImageView(),UIImageView(),UIImageView()]
    var ratingLabel: UILabel!
    var restrauImage: UIImageView!
    var friendImage: [String] = ["user1.png","user2.png","user3.png"]
    var imageViewAmenities: [UIImageView]! = [UIImageView(),UIImageView(),UIImageView(),UIImageView()]
    var amenitiesLabels: [UILabel]! = [UILabel(),UILabel(),UILabel(),UILabel()]
    var imageViewFriends: [UIImageView]! = [UIImageView(),UIImageView(),UIImageView()]
    
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
    
    //setting up cards content
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
        for index in 0...2 {
            imagePrice[index].frame = CGRect(x: (self.frame.size.width*CGFloat(215+15*index))/270, y: (self.frame.size.height*25)/386, width: (self.frame.size.width*7)/270, height: (self.frame.size.height*13)/386)
        }
       
        //amenity icons
        let imageArray = [UIImage(named:"yellowclock.png"),UIImage(named:"map_icon.png"),UIImage(named:"wifi_icon.png"),UIImage(named:"food-delivery.png")]
        
        for index in 0...3 {
            imageViewAmenities[index].image = imageArray[index]
            imageViewAmenities[index].frame = CGRect(x: (self.frame.size.width)*CGFloat(65*index+30)/270, y: (self.frame.size.height*75)/386, width: 20, height: 20)
        }
        
        //labels for the amenity icons
        let textArray = ["upto 11 PM","2.5 m","Wifi","Delivery"]
        amenitiesLabels[0] = UILabel(frame: CGRect(x: (self.frame.size.width*18)/270, y: (self.frame.size.height*88)/386, width:60, height: 40))
        amenitiesLabels[1] = UILabel(frame: CGRect(x: (self.frame.size.width)/3, y: (self.frame.size.height*88)/386, width:60, height: 40))
        amenitiesLabels[2] = UILabel(frame: CGRect(x: (self.frame.size.width*16)/27, y: (self.frame.size.height*88)/386, width:60, height: 40))
        amenitiesLabels[3] = UILabel(frame: CGRect(x: (self.frame.size.width*217)/270, y: (self.frame.size.height*88)/386, width:60, height: 40))
        
        for index in 0...3 {
            amenitiesLabels[index].textAlignment = .center
            amenitiesLabels[index].center.x = imageViewAmenities[index].center.x
            amenitiesLabels[index].text = textArray[index]
            amenitiesLabels[index].textColor = UIColor.darkGray
            amenitiesLabels[index].font = UIFont(name: "Bariol-Regular", size: 10)
            amenitiesLabels[index].contentMode = .scaleAspectFill
        }
        
        //imageview for restaurant image
        restrauImage = UIImageView(image: UIImage(named: "restaurant-1.jpg"))
        restrauImage.frame = CGRect(x: self.frame.size.width/15, y: (self.frame.size.height*127)/386, width: self.frame.size.width - (self.frame.size.width*7)/54, height: self.frame.size.height - (self.frame.size.height*83)/193)
        
        //text to image
        let imageRating = "greenRect.png"
        let imageRtng = UIImage(named: imageRating)
        let imageViewRating = UIImageView(image: imageRtng)
        imageViewRating.frame = CGRect(x: (self.frame.size.width*2)/3, y: (self.frame.size.height*10)/386, width: (self.frame.size.width*4)/27, height: (self.frame.size.height*30)/386)
        ratingLabel = UILabel(frame: CGRect(x: (self.frame.size.width)/27, y: (self.frame.size.height*3)/386, width: (self.frame.size.width*25)/270, height: (self.frame.size.height*25)/386))
        ratingLabel.text = "4.4"
        ratingLabel.textColor = UIColor.white
        ratingLabel.font = cuisines.font.withSize(13)
        imageViewRating.addSubview(ratingLabel)
        restrauImage.addSubview(imageViewRating)
        
        //3 circular friends image along with +n count
        for index in 2...4 {
            let imageUser1 = "user1.png"
            let imageUsr1 = UIImage(named: imageUser1)
            imageViewFriends[index - 2] = UIImageView(image: imageUsr1)
            imageViewFriends[index - 2].frame = CGRect(x: CGFloat((Int(self.frame.size.width)*((index-1)*2))/27), y: (self.frame.size.height*360)/386, width: (self.frame.size.width*2)/27, height: (self.frame.size.height*18)/386)
            imageViewFriends[index - 2].layer.borderWidth = 1
            imageViewFriends[index - 2].layer.masksToBounds = false
            imageViewFriends[index - 2].layer.borderColor = UIColor.white.cgColor
            imageViewFriends[index - 2].layer.cornerRadius = imageViewFriends[index - 2].frame.height/2
            imageViewFriends[index - 2].clipsToBounds = true
        }
        
        let addCount = UILabel(frame: CGRect(x: (self.frame.size.width*85)/270, y: (self.frame.size.height*350)/386, width:(self.frame.size.width*2)/9, height: (self.frame.size.height*40)/386))
        addCount.text = "+17 friends"
        addCount.textColor = UIColor.darkGray
        addCount.font = UIFont(name: "Bariol-Thin", size: 10)
        
        for index in 0...2 {
            self.addSubview(imagePrice[index])
            self.addSubview(imageViewAmenities[index])
            self.addSubview(amenitiesLabels[index])
            self.addSubview(imageViewFriends[index])
        }
        self.addSubview(restrauName)
        self.addSubview(cuisines)
        self.addSubview(imageViewAmenities[3])
        self.addSubview(amenitiesLabels[3])
        self.addSubview(restrauImage)
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
    
    //delegate in which call comes when dragged , here we are updating overlay when the view is dragged
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
    
    //overlay view is updated about the movement direction by which it sets the mode that helps it determine to put different overlas for like , unlike nd already been
    func updateOverlay(_ distance: CGFloat, _ ydist: CGFloat) -> Void {
        
        if ydist < -10 && distance > -10 && distance < 10{
            overlayView.frame = CGRect(x:5, y:15, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*80)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeTop)
            overlayView.alpha = CGFloat(min(fabsf(Float(ydist))/100 + 0.2, 0.7))
        }else if distance > 10 {
            overlayView.frame = CGRect(x:5, y:15, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*80)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeRight)
            overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100 + 0.2, 0.9))
        } else if distance < 0{
            overlayView.frame = CGRect(x:self.frame.size.width-120, y:0, width: (self.frame.size.width*5)/27, height: (self.frame.size.height*40)/386)
            overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeLeft)
            overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100 + 0.2, 0.9))
        }
        
    }
    
    //this is called when swipe is ended and according to the direction we call different functions or else if there is not much movement determined by ACTION_MARGIN then we animate the card and puts it back to its position
    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        let floatYFromCenter = Float(yFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else if floatYFromCenter < -ACTION_MARGIN {
            self.topAction()
        }else {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    //In this we animates the card in right direction and lets other delegate know about the action
    func rightAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.5,
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
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.center = finishPoint
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
    
    func topAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: 2 * CGFloat(xFromCenter)+self.originPoint.x, y: -300)
        UIView.animate(withDuration: 0.5,
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
        UIView.animate(withDuration: 2,
                       animations: {
                        self.overlayView.alpha = 1
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
        UIView.animate(withDuration: 2,
                       animations: {
                        self.center = finishPoint
                        self.transform = CGAffineTransform(rotationAngle: 1)
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
    
    func topClickAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: self.center.x, y: -self.frame.height)
        UIView.animate(withDuration: 2,
                       animations: {
                        self.center = finishPoint
                        self.transform = CGAffineTransform(rotationAngle: 1)
        }, completion: {
            (value: Bool) in
            self.removeFromSuperview()
        })
        delegate.cardSwipedTop(self)
    }

}
