//
//  OverlayView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode {
    case ggOverlayViewModeLeft
    case ggOverlayViewModeRight
    case ggOverlayViewModeTop
}

class OverlayView: UIView{
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.ggOverlayViewModeLeft
    var imageView: UIImageView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        imageView = UIImageView(image: UIImage(named: "noButton"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(imageView)
    }

    func setMode(_ mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode

        if _mode == GGOverlayViewMode.ggOverlayViewModeLeft {
            imageView.image = UIImage(named: "noButton")
            imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        } else if _mode == GGOverlayViewMode.ggOverlayViewModeTop{
            imageView.image = UIImage(named: "beenthereButton")
            imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }else {
            imageView.image = UIImage(named: "yesButton")
            imageView.frame = CGRect(x: 0, y: 0, width:self.frame.size.width, height: self.frame.size.height)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
