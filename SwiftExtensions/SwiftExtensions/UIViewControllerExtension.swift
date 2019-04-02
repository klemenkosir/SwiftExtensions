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
	
	public func addViewFromViewController(_ vc: UIViewController) {
        vc.willMove(toParent: self)
		vc.view.frame = self.view.bounds
		self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
	}
	
	public func removeViewAndViewController() {
		self.view.removeFromSuperview()
        self.removeFromParent()
	}
	
	public func hideKeyboardWhenTappedAround() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		tap.cancelsTouchesInView = false
		tap.delegate = self
		view.addGestureRecognizer(tap)
	}
	
    @objc public func dismissKeyboard() {
		view.endEditing(true)
	}
    
    public func putOnNavigationController() -> UINavigationController! {
        guard self.navigationController == nil, self.parent == nil else { return nil }
        let navVC = UINavigationController(rootViewController: self)
        navVC.navigationBar.isHidden = true
        return navVC
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
			
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[versionLabel]|", metrics: nil, views: ["versionLabel" : self.versionLabel!]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[versionLabel]|", metrics: nil, views: ["versionLabel" : self.versionLabel!]))
			
			let build = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
			versionLabel!.text = "Dev Build \(build)"
			
			versionLabel!.layer.zPosition = CGFloat.greatestFiniteMagnitude
		}
	}
}
