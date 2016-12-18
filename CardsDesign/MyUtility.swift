//
//  MyUtility.swift
//  CardsDesign
//
//  Created by Abhinay Varma on 19/12/16.
//  Copyright © 2016 Abhinay Varma. All rights reserved.
//

import UIKit

class MyUtility: NSObject {
    static func firstAvailableUIViewController(fromResponder responder: UIResponder) -> UIViewController? {
        func traverseResponderChainForUIViewController(responder: UIResponder) -> UIViewController? {
            if let nextResponder = responder.next {
                if let nextResp = nextResponder as? RestaurantFeed {
                    return nextResp
                } else {
                    return traverseResponderChainForUIViewController(responder: nextResponder)
                }
            }
            return nil
        }
        
        return traverseResponderChainForUIViewController(responder: responder)
    }
}
