//
//  RestaurantDetail.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 17/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//
import UIKit

class RestaurantDetail: UIViewController, UIScrollViewDelegate {
   
    var scrollView: UIScrollView!
    var containerView = UIView()
    var restrau:RestaurantModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonOne = UIButton(type:UIButtonType.system) as UIButton
        
        
        buttonOne.frame = CGRect(x:self.view.frame.size.width/2-120, y:10, width:10, height:10)
        buttonOne.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        buttonOne.addTarget(self, action: Selector(("buttonAction1x1:")), for: UIControlEvents.touchUpInside)
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width:600, height:1000)
        
        containerView = UIView()
        
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        containerView.addSubview(buttonOne)
        self.navigationController?.isNavigationBarHidden = true
        
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
