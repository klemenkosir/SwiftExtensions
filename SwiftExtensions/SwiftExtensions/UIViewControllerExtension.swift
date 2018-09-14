//
//  UIViewControllerExtension.swift
//  
//
//  Created by Klemen Kosir on 30/01/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

private var versionLabelKey: UInt8 = 0

extension UIViewController: UIGestureRecognizerDelegate {
	
	func addViewFromViewController(_ vc: UIViewController) {
		vc.willMove(toParentViewController: self)
		vc.view.frame = self.view.bounds
		self.view.addSubview(vc.view)
		self.addChildViewController(vc)
		vc.didMove(toParentViewController: self)
	}
	
	func removeViewAndViewController() {
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
	
	func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		tap.cancelsTouchesInView = false
		tap.delegate = self
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	//GestureRecognizer Delegate
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if touch.view?.isKind(of: UIButton.self) == true {
			return false
		}
		return true
	}
}

public extension UIWindow {
	
	fileprivate var versionLabel: UILabel? {
		get {
			return objc_getAssociatedObject(self, &versionLabelKey) as? UILabel
		}
		set(newValue) {
			if let nv = newValue {
				objc_setAssociatedObject(self, &versionLabelKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
	}
	
	func setBuildNumberVisible(_ visible: Bool, textColor: UIColor) {
		self.versionLabel?.removeFromSuperview()
		if visible {
			self.versionLabel = UILabel()
			self.versionLabel!.translatesAutoresizingMaskIntoConstraints = false
			self.versionLabel!.textColor = textColor
			self.versionLabel!.font = UIFont.systemFont(ofSize: 10.0)
			self.addSubview(self.versionLabel!)
			
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[versionLabel]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["versionLabel" : self.versionLabel!]))
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[versionLabel]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["versionLabel" : self.versionLabel!]))
			
			let build = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
			versionLabel!.text = "Dev Build \(build)"
			
			versionLabel!.layer.zPosition = CGFloat.greatestFiniteMagnitude
		}
	}
}
