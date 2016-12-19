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
        self.backgroundColor = UIColor.white
        imageView = UIImageView(image: UIImage(named: "noButton"))
        imageView.frame = CGRect(x: 180, y: 35, width: 50, height: 80)
        self.addSubview(imageView)
    }

    func setMode(_ mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode

        if _mode == GGOverlayViewMode.ggOverlayViewModeLeft {
            imageView.image = UIImage(named: "noButton")
            imageView.frame = CGRect(x: 180, y: 35, width: 44, height: 75)
        } else if _mode == GGOverlayViewMode.ggOverlayViewModeTop{
            imageView.image = UIImage(named: "beenthereButton")
            imageView.frame = CGRect(x: -40, y: 35, width: 60, height: 80)
        }else {
            imageView.image = UIImage(named: "yesButton")
            imageView.frame = CGRect(x: -40, y: 35, width: 50, height: 80)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
