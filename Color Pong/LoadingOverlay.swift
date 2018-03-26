//
//  LoadingOverlay.swift
//  Color Pong
//
//  Created by Marco Starker on 09.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = view.frame
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.userInteractionEnabled = true
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}