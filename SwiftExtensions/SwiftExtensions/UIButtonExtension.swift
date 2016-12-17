//
//  UIButtonExtension.swift
//
//
//  Created by Klemen Kosir on 20/07/16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import UIKit

private var autoAdjustFontSizeKey: UInt8 = 0
private var alignImageAndTitleVerticallyKey: UInt8 = 0
private var titleVerticalPaddingKey: UInt8 = 0

extension UIButton {
	
	@IBInspectable var autoAdjustFontSize: Bool {
		get {
			return (objc_getAssociatedObject(self, &autoAdjustFontSizeKey) as? NSNumber)?.boolValue ?? false
		}
		set(newValue) {
			let nv = NSNumber(value: newValue as Bool)
			objc_setAssociatedObject(self, &autoAdjustFontSizeKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	@IBInspectable var alignImageAndTitleVertically: Bool {
		get {
			return (objc_getAssociatedObject(self, &alignImageAndTitleVerticallyKey) as? NSNumber)?.boolValue ?? false
		}
		set(newValue) {
			let nv = NSNumber(value: newValue as Bool)
			objc_setAssociatedObject(self, &alignImageAndTitleVerticallyKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	@IBInspectable var titleVerticalPadding: CGFloat {
		get {
			return CGFloat((objc_getAssociatedObject(self, &titleVerticalPaddingKey) as? NSNumber)?.doubleValue ?? 8.0)
		}
		set(newValue) {
			let nv = NSNumber(value: Double(newValue))
			objc_setAssociatedObject(self, &titleVerticalPaddingKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		
		if self.autoAdjustFontSize {
			self.titleLabel?.numberOfLines = 1
			self.titleLabel?.adjustsFontSizeToFitWidth = true
			self.titleLabel?.minimumScaleFactor = 0.5
			self.titleLabel?.lineBreakMode = .byClipping
		}
		
		if alignImageAndTitleVertically {
			updateAlignImageAndTitleVertically()
		}
		
	}
	
	func removeAllTouchEvents() {
		self.removeTarget(nil, action: nil, for: .allTouchEvents)
	}
	
	func updateAlignImageAndTitleVertically() {
		//		self.sizeToFit()
		let imageBounds = self.imageView!.bounds
		let titleBounds = self.titleLabel!.bounds
		let totalHeight = imageBounds.height + titleVerticalPadding + titleBounds.height
		
		self.imageEdgeInsets = UIEdgeInsets(
			top: -(totalHeight - imageBounds.height),
			left: 0,
			bottom: 0,
			right: -titleBounds.width
		)
		
		self.titleEdgeInsets = UIEdgeInsets(
			top: 0,
			left: -imageBounds.width,
			bottom: -(totalHeight - titleBounds.height),
			right: 0
		)
	}
	
	//	open override var intrinsicContentSize: CGSize {
	//		if !alignImageAndTitleVertically {
	//			return super.intrinsicContentSize
	//		}
	//		let imageBounds = self.imageView!.bounds
	//		let titleBounds = self.titleLabel!.bounds
	//
	//		let width = imageBounds.width > titleBounds.width ? imageBounds.width : titleBounds.width
	//		let height = imageBounds.height + titleVerticalPadding + titleBounds.height
	//
	//		return CGSize(width: width, height: height)
	//	}
	
}
