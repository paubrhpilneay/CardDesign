//
//  RestaurantDetail.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 17/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//
import UIKit

class RestaurantDetail: UIViewController, UIScrollViewDelegate, HorizontaScrollDelegate {
   
    var scrollView: UIScrollView!
    var containerView = UIView()
    var restrau:RestaurantModel!
    var imageArr : [String] = ["deli2","deli3","deli4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonOne: UIButton = UIButton(frame:CGRect(x:self.view.frame.size.width/2-133, y:30, width:7, height:10))
        buttonOne.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        buttonOne.addTarget(self, action: #selector(newFunc), for: UIControlEvents.touchUpInside)
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        
        let restaurantName = UILabel(frame: CGRect(x: 25, y: 47, width:150, height: 40))
        restaurantName.text = "Smoke House Deli"
        restaurantName.font = UIFont(name: "Bariol-Regular", size: 18)
        restaurantName.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let cuisines = UILabel(frame: CGRect(x: 25, y: 71, width:90, height: 30))
        cuisines.text = "Europian,Italian"
        cuisines.font = UIFont(name: "Bariol-Light", size: 12)
        cuisines.textColor = UIColor.darkGray
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width:view.frame.width, height:1000)
        
        containerView = UIView()
    
        let imageUsr3 = UIImage(named: "stars")
        let imageViewStars = UIImageView(image: imageUsr3)
        imageViewStars.frame = CGRect(x: 25, y: 117, width: 120, height: 15)
        
        let rating = UILabel(frame: CGRect(x: 160, y: 110, width:25, height: 30))
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
        imageView1.frame = CGRect(x: 255, y: 60, width: 7, height: 13)
        imageView2.frame = CGRect(x: 270,y: 60, width: 7, height: 13)
        imageView3.frame = CGRect(x: 285, y: 60, width: 7, height: 13)
        
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
        
        imageViewClock.frame = CGRect(x: 30, y: 160, width: 14, height: 14)
        imageViewLocation.frame = CGRect(x: 110, y: 158, width: 15, height: 17)
        imageViewWifi.frame = CGRect(x: 190, y: 160, width: 17, height: 12)
        imageViewDelivery.frame = CGRect(x: 270, y: 158, width: 13, height: 17)
        
        
        
        let ocTime = UILabel(frame: CGRect(x: 18, y: 167, width:60, height: 40))
        ocTime.text = "upto 11 PM"
        ocTime.textColor = UIColor.gray
        ocTime.font = UIFont(name: "Bariol-Regular", size: 10)
        
        let locationTime = UILabel(frame: CGRect(x: 106, y: 167, width:40, height: 40))
        locationTime.text = "2.5 m"
        locationTime.textColor = UIColor.gray
        locationTime.font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        let wifi = UILabel(frame: CGRect(x: 190, y: 167, width:40, height: 40))
        wifi.text = "Wifi"
        wifi.textColor = UIColor.gray
        wifi.font = UIFont(name: "Bariol-Regular", size: 10)
        
        
        let delivery = UILabel(frame: CGRect(x: 260, y: 167, width:40, height: 40))
        delivery.text = "Delivery"
        delivery.textColor = UIColor.gray
        delivery.font = UIFont(name: "Bariol-Regular", size: 10)
        
        let hScroll = HorizontalScroll(frame:CGRect(x:0, y:220, width: view.frame.width, height:230))
        hScroll.backgroundColor = UIColor.gray
        hScroll.delegate = self
        
        let honorLabel:UILabel = UILabel(frame:CGRect(x:20, y:470, width:80,height:40))
        honorLabel.text = "HONORS"
        honorLabel.textColor = UIColor.darkGray
        honorLabel.font = UIFont(name: "Bariol-Thin", size: 12)
        
        let imageHonors = ["honor1","honor2","honor3","honor4"]
        var offset: Int = 10
        for index in 0 ... (imageHonors.count - 1) {
            let imageHonor = UIImage(named: imageHonors[index])
            let imageViewHonor = UIImageView(image: imageHonor)
            imageViewHonor.frame = CGRect(x: offset, y: 510, width: 60, height: 60)
            offset = offset + 80
            containerView.addSubview(imageViewHonor)
        }
        
        let topLabel = UILabel(frame:CGRect(x:20, y:590 , width:140, height:40))
        topLabel.text = "TOP THREE PICK"
        topLabel.textColor = UIColor.darkGray
        topLabel.font = UIFont(name: "Bariol-Thin", size: 12)
        
        let topImgArr = ["bestpick1","bestpick2","bestpick3"]
        for index in 0...(topImgArr.count - 1) {
            let imageTop = UIImage(named:topImgArr[index])
            let imageViewTop = UIImageView(image: imageTop)
            imageViewTop.frame = CGRect(x:20, y:640 + offset , width:20, height:20)
            let labelImage = UILabel(frame:CGRect(x:55,y:660+offset,width:100,height:40))
            labelImage.font = UIFont(name: "Bariol-Regular", size: 12)
        }
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
        containerView.addSubview(honorLabel)
        containerView.addSubview(topLabel)
        self.navigationController?.isNavigationBarHidden = true
    }
    func numberOfScrollViewElements() -> Int {
        return 2
    }
    
    func elementAtScrollViewIndex(index: Int) -> UIView {
        let newview:UIView = UIView(frame:CGRect(x:0, y:0, width:Int(view.frame.size.width), height:230))
        
        let moreImage = UIImage(named: imageArr[index])
        let moreImageView = UIImageView(image:moreImage)
        moreImageView.frame = newview.frame
        newview.addSubview(moreImageView)
        return newview
    }
    
    func newFunc() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
