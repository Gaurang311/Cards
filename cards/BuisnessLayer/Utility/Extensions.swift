//
//  Extensions.swift
//  cards
//
//  Created by Gaurang Lathiya on 25/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

extension UIViewController {
    
    func getNavigationBarHeight() -> CGFloat {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navBarHeight: CGFloat = 44.0
        if let navcontroller = self.navigationController {
            navBarHeight = navcontroller.navigationBar.frame.height
        }
        return statusBarHeight + navBarHeight
    }
    
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let uiAlertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle:.alert)
            
            uiAlertController.addAction(
                UIAlertAction.init(title: "OK", style: .default, handler: { (UIAlertAction) in
                    uiAlertController.dismiss(animated: true, completion: nil)
                }))
            self.topMostViewController().present(uiAlertController, animated: true, completion: nil)
        }
    }
    
    func disableSwipeLeftToBack() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func enableSwipeLeftToBack() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func setAppThemeNavigationBar() {
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.white
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    func setTransparentNavigationBar() {
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.clear
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    
    func showNoInternetAvailable() {
        // Status Bar Warning Notification
        let banner = StatusBarNotificationBanner(title: Constants.kNoInterNetConnection, style: .warning)
        banner.backgroundColor = UIColor.red
        banner.titleLabel?.textColor = UIColor.white
        banner.tag = 100
        banner.autoDismiss = false
        banner.dismissOnTap = true
        banner.show(queuePosition: .front,
                    bannerPosition: .top)
    }
    
    func dismissNoInternetAvailable() {
        
        var isBannerFound: Bool = false
        for subView in self.view.subviews {
            if subView.isKind(of:StatusBarNotificationBanner.self) {
                if subView.tag == 100 {
                    let banner = subView as! StatusBarNotificationBanner
                    banner.dismiss()
                    isBannerFound = true
                    break
                }
            }
        }
        
        if isBannerFound == false {
            for subView in UIApplication.shared.delegate!.window!!.subviews {
                if subView.isKind(of:StatusBarNotificationBanner.self) {
                    if subView.tag == 100 {
                        let banner = subView as! StatusBarNotificationBanner
                        banner.dismiss()
                        isBannerFound = true
                        break
                    }
                }
            }
        }
        
    }
    
    func showBanner(withMessage message: String) {
        // Status Bar Warning Notification
        let banner = StatusBarNotificationBanner(title: message, style: .warning)
        banner.backgroundColor = UIColor.white
        banner.titleLabel?.textColor = UIColor.black
        banner.autoDismiss = true
        banner.duration = 2.0
        banner.show(queuePosition: .front, bannerPosition: .top)
    }
    
    func showNavigationbarBanner(withTitle title: String, subtitle: String) {
        // Notification bar covered
        let banner = NotificationBanner.init(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: .warning, colors: nil)
        banner.backgroundColor = UIColor.white
        banner.titleLabel?.textColor = UIColor.black
        banner.titleLabel?.textAlignment = .center
        banner.subtitleLabel?.textColor = UIColor.black
        banner.subtitleLabel?.textAlignment = .center
        banner.autoDismiss = true
        banner.duration = 2.0
        banner.show(queuePosition: .front, bannerPosition: .top)
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
