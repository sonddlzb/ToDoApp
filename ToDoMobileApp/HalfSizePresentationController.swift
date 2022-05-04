//
//  HalfSizePresentationController.swift
//  ToDoMobileApp
//
//  Created by đào sơn on 25/04/2022.
//

import UIKit

// create a half screen presentation viewcontroller
class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height/2)
    }
}
class OneFifthSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height*4/5, width: bounds.width, height: bounds.height/5)
    }
}
