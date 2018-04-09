//
//  UITextFieldExtension.swift
//
//
//  Created by Klemen Kosir on 25/07/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

private var placeholderColorKey: UInt8 = 0

public extension UITextField {
	
	@IBInspectable var placeholderColor: UIColor? {
		get {
			return objc_getAssociatedObject(self, &placeholderColorKey) as? UIColor
		}
		set(newValue) {
			 self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
			objc_setAssociatedObject(self, &placeholderColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
}
