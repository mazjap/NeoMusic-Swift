//
//  UIAlertController+Extension.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 8/9/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

enum ButtonOptions: String {
    case ok = "Ok"
    case cancel = "Cancel"
    case quit = "Quit"
    case retry = "Retry"
    
    func getStyle() -> UIAlertAction.Style {
        switch self {
        case .ok:
            return .default
        case .cancel:
            return .cancel
        case .quit:
            return .destructive
        case .retry:
            return .default
        }
    }
}

extension UIAlertController {
    static func alert(title: String, message: String, vc: UIViewController, buttons: [(ButtonOptions, (UIAlertAction) -> Void)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for pair in buttons {
            alertController.addAction(UIAlertAction(title: pair.0.rawValue, style: pair.0.getStyle(), handler: pair.1))
        }
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        // Iterate through presented view controllers to finc the top one
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // Check to see if the currently presented view controller is the view controller passed
            if topController == vc {
                vc.present(alertController, animated: true)
            }
        }
    }
}
