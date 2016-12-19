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
        let tbvc = tabBarController as! MainTabBar
        restaurants = tbvc.restaurants
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        draggableBackground.restaurants = restaurants
        draggableBackground.loadCards()
        self.view.addSubview(draggableBackground)
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func imageWithImage(image: UIImage, newSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}
