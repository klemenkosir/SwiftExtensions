//
//  UIGestureRecognizerExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 17. 12. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
	
	func removeFromView() {
		self.view?.removeGestureRecognizer(self)
	}
	
}
