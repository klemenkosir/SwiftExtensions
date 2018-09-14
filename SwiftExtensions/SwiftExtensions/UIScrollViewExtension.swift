//
//  UIScrollViewExtension.swift
//
//
//  Created by Klemen Kosir on 13/07/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

private var originalFrameKey: UInt8 = 0
private var wasUsingAutolayoutKey: UInt8 = 0
private var bottomOffsetKey: UInt8 = 0

public extension UIScrollView {
	
	fileprivate var originalFrame: CGRect? {
		get {
			return (objc_getAssociatedObject(self, &originalFrameKey) as? NSValue)?.cgRectValue
		}
		set(newValue) {
			if let newValue = newValue {
				let nv = NSValue(cgRect: newValue)
				objc_setAssociatedObject(self, &originalFrameKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
	}
	
	fileprivate var wasUsingAutoLayout: Bool? {
		get {
			return (objc_getAssociatedObject(self, &wasUsingAutolayoutKey) as? NSNumber)?.boolValue
		}
		set(newValue) {
			if let nvB = newValue {
				let nv = NSNumber(value: nvB)
				objc_setAssociatedObject(self, &wasUsingAutolayoutKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
	}
	
	fileprivate var bottomOffset: CGFloat {
		get {
			return CGFloat((objc_getAssociatedObject(self, &bottomOffsetKey) as? NSNumber)?.doubleValue ?? 0.0)
		}
		set(newValue) {
			let nv = NSNumber(value: Double(newValue) as Double)
			objc_setAssociatedObject(self, &bottomOffsetKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	func enableScrollsToTop() {
		guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
		let view = vc.view
		self.disableScrollsToTop(view!)
		self.scrollsToTop = true
	}
	
	fileprivate func disableScrollsToTop(_ view: UIView) {
		for subview in view.subviews {
			self.disableScrollsToTop(subview)
		}
		if let sv = view as? UIScrollView {
			sv.scrollsToTop = false
		}
	}
	
	func enableAutoscroll(withOffset bottomOffset: CGFloat) {
		self.bottomOffset = bottomOffset
		self.registerKeyboardNotifications()
	}
	
	func enableAutoscroll() {
		self.registerKeyboardNotifications()
	}
	
	func disableAutoscroll() {
		self.unregisterKeyboardNotifications()
	}
	
	fileprivate func registerKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	fileprivate func unregisterKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc fileprivate func keyboardWillShow(_ notification: NSNotification) {
		guard let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue/*, (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0 > 0*/  else {
			return
		}
		if self.originalFrame == nil {
            self.layoutIfNeeded()
			self.originalFrame = self.frame
		}
		self.wasUsingAutoLayout = !self.translatesAutoresizingMaskIntoConstraints
		self.translatesAutoresizingMaskIntoConstraints = true
        self.frame = self.originalFrame!
        
//        let topOffset = self.convert(self.bounds.origin, to: UIApplication.shared.keyWindow).y
        if #available(iOS 11.0, *) {
            let safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets ?? .zero
            self.frame.size.height = self.originalFrame!.size.height - rect.size.height + self.bottomOffset + safeAreaInsets.bottom /*+ topOffset - (safeAreaInsets?.top ?? 0.0)*/
        } else {
            // Fallback on earlier versions
            self.frame.size.height = self.originalFrame!.size.height - rect.size.height + self.bottomOffset /*+ topOffset - 20.0*/
        }
		//		self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 65.0, 0.0)
		self.contentInset = UIEdgeInsets.zero
		self.layoutIfNeeded()
		//		self.checkIfCurrentFirstResponderIsOffScreen()
		//		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
	}
	
	@objc fileprivate func keyboardWillHide(_ notification: Foundation.Notification) {
		guard self.wasUsingAutoLayout != nil else { return }
		self.frame = self.originalFrame ?? CGRect.zero
		self.contentInset = UIEdgeInsets.zero
		self.translatesAutoresizingMaskIntoConstraints = !self.wasUsingAutoLayout!
		self.layoutIfNeeded()
		self.originalFrame = nil
		//		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
	}
	
//	fileprivate func checkIfCurrentFirstResponderIsOffScreen() {
//		guard let firstResponderView = self.currentFirstResponder() as? UIView else {
//			return
//		}
//		var firstResponderViewFrame = firstResponderView.bounds
//		firstResponderViewFrame.size.height += 100.0
//		self.scrollRectToVisible(firstResponderViewFrame, animated: true)
//	}
	
}
