//
//  ViewController.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 15/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var restaurants = [RestaurantModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        draggableBackground.restaurants = restaurants
        draggableBackground.loadCards()
        self.view.addSubview(draggableBackground)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
