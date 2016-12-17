//
//  UILabelExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 17. 12. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import UIKit

extension UILabel {
	
	@IBInspectable var isVertical: Bool {
		get {
			return self.isVertical
		}
		set {
			self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
		}
	}
	
	func setText(html: String) {
		if let htmlData = html.data(using: String.Encoding.unicode) {
			do {
				self.attributedText = try NSAttributedString(data: htmlData,
				                                             options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
				                                             documentAttributes: nil)
			} catch let e as NSError {
				print("Couldn't parse \(html): \(e.localizedDescription)")
			}
		}
	}
	
}
