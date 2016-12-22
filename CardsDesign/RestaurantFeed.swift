//
//  ViewController.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 15/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit

class RestaurantFeed: UIViewController {
    var restaurants = [RestaurantModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assigning all restaurants that we got from recomendations to the property restaurants of this class
        let tbvc = tabBarController as! MainTabBar
        restaurants = tbvc.restaurants
        
        //loading cards and other page content
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        draggableBackground.restaurants = restaurants
        draggableBackground.loadCards()
        
        
        self.view.addSubview(draggableBackground)
        //hiding nav bar
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        let image:UIImage = UIImage(named: "tabRecoms")!
        let newImage:UIImage = self.imageWithImage(image: image, newSize: CGSize(width:17, height:17))
        tabBarItem = UITabBarItem(title: "", image: newImage, tag: 0)
    }
    
    //resizing image for the tab bar
    func imageWithImage(image: UIImage, newSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}
