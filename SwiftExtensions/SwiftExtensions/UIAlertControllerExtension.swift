//
//  UIAlertControllerExtension.swift
//  
//
//  Created by Klemen Kosir on 27/04/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

private var alertWindowKey: UInt8 = 0

public extension UIAlertController {
	
	private var alertWindow: UIWindow {
		get {
			return objc_getAssociatedObject(self, &alertWindowKey) as! UIWindow
		}
		set {
			objc_setAssociatedObject(self, &alertWindowKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	static func showBasicPopup(_ title: String?, message: String?, autoDismiss: Bool, onViewController vc: UIViewController? = nil) {
		guard let vc = vc else { return }
		let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
		if autoDismiss {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
				popup.dismiss(animated: true, completion: nil)
			})
		}
		else {
			popup.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		}
		if UIDevice.current.userInterfaceIdiom == .pad {
			popup.popoverPresentationController?.sourceView = vc.view
			popup.popoverPresentationController?.sourceRect = vc.view.bounds
		}
		vc.present(popup, animated: true, completion: nil)
	}
	
	static func showInfoPopup(_ title: String?, message: String?, autoDismiss: Bool, onViewController vc: UIViewController? = nil) -> UIAlertController? {
		guard let vc = vc else { return nil }
		let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
		if autoDismiss {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
				popup.dismiss(animated: true, completion: nil)
			})
		}
		else {
			popup.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		}
		if UIDevice.current.userInterfaceIdiom == .pad {
			popup.popoverPresentationController?.sourceView = vc.view
			popup.popoverPresentationController?.sourceRect = vc.view.bounds
		}
		vc.present(popup, animated: true, completion: nil)
		return popup
	}
	
	func show(_ animated: Bool = true, completion: (() -> Void)? = nil) {
		alertWindow = UIWindow(frame: UIScreen.main.bounds)
		alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = UIWindow.Level.alert
		
		let rootVC = UIViewController()
		alertWindow.rootViewController = rootVC
		
		alertWindow.makeKeyAndVisible()
		rootVC.present(self, animated: animated, completion: completion)
	}
	
	func hide(_ animated: Bool = true) {
		self.dismiss(animated: animated, completion: nil)
	}
}
