//
//  GetFirebaseData.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 16/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    var restaurants = [RestaurantModel]()
    let kBarHeight:CGFloat = 40
    var recos:String = ""
    var friends:String = ""
    var userId:String = ""
    
    override func viewWillLayoutSubviews() {
    
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = self.view.frame.size.height - kBarHeight + 2
        self.tabBar.frame = tabFrame
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
