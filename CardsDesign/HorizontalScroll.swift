//
//  HorizontalScroll.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 20/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit

@objc protocol HorizontaScrollDelegate {
    
    func numberOfScrollViewElements() -> Int
    
    func elementAtScrollViewIndex(index: Int) -> UIView
}

class HorizontalScroll:UIView {
    var delegate: HorizontaScrollDelegate?
    var scroller: UIScrollView!
    
    let PADDING: Int = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpScroll()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        setUpScroll()
    }
    
    override func didMoveToSuperview() {
       reload()
    }
    
    func setUpScroll() {
      scroller = UIScrollView()
      self.addSubview(scroller)
      scroller.translatesAutoresizingMaskIntoConstraints = false
      let dict = ["scroller": scroller]
      
      let constraint1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: dict)
      let constraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: dict)
      self.addConstraints(constraint1)
      self.addConstraints(constraint2)
    }
    
    func reload() {
        if let del = delegate {
            var xOffset: CGFloat = 0
            for index in 0...del.numberOfScrollViewElements() {
              let newview:UIView = del.elementAtScrollViewIndex(index: index)
              newview.frame = CGRect(x:xOffset, y:newview.frame.origin.y, width:newview.frame.size.width, height:newview.frame.size.height)
              if newview.frame.height == 150  {
                 xOffset = xOffset + CGFloat(PADDING) + newview.frame.size.width
              }else {
                  xOffset = xOffset + CGFloat(PADDING) + newview.frame.size.width + CGFloat(20.0)
              }
              scroller.addSubview(newview)
            }
          scroller.contentSize = CGSize(width: self.frame.size.width * CGFloat(del.numberOfScrollViewElements()) + 10, height: self.frame.size.height)
        }
    }
}
