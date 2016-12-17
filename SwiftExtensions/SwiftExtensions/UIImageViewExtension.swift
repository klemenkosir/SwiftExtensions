//
//  UIImageViewExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 17. 12. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import Foundation

extension UIImageView {
	
	enum ScalingFilters: Int {
		case linear
		case nearest
		case trilinear
		
		static func fromString(_ string: String) -> Int {
			switch string {
			case kCAFilterLinear:
				return 0
			case kCAFilterNearest:
				return 1
			case kCAFilterTrilinear:
				return 2
			default:
				return 0
			}
		}
		
		func toString() -> String {
			switch self {
			case .linear:
				return kCAFilterLinear
			case .nearest:
				return kCAFilterNearest
			case .trilinear:
				return kCAFilterTrilinear
			}
		}
	}
	
	@IBInspectable var miniFilter: Int {
		get {
			return ScalingFilters.fromString(self.layer.minificationFilter)
		}
		set {
			self.layer.minificationFilter = ScalingFilters(rawValue: newValue)?.toString() ?? ""
		}
	}
	
	@IBInspectable var magFilter: Int {
		get {
			return ScalingFilters.fromString(self.layer.magnificationFilter)
		}
		set {
			self.layer.magnificationFilter = ScalingFilters(rawValue: newValue)?.toString() ?? ""
		}
	}
	
	func setImageWithTransition(_ image: UIImage?, transition: UIViewAnimationOptions) {
		DispatchQueue.main.async { () -> Void in
			UIView.transition(with: self, duration: 0.2, options: transition, animations: { () -> Void in
				self.image = image
			}) { (completed) -> Void in
				
			}
		}
	}
	
	func setImageWithTransition(_ image: UIImage?, duration: Double, transition: UIViewAnimationOptions) {
		DispatchQueue.main.async { () -> Void in
			UIView.transition(with: self, duration: duration, options: transition, animations: { () -> Void in
				self.image = image
			}) { (completed) -> Void in
				
			}
		}
	}
	
	func getImage(_ imageURL: String?) {
		self.getImage(imageURL, animateOnFirstLoad: true, transition: .transitionCrossDissolve)
	}
	
	func getImage(_ imageURL: String?, animateOnFirstLoad: Bool, transition: UIViewAnimationOptions) {
		guard  let imageURL = imageURL else { return }
		self.image = nil
		DispatchQueue.global(qos: .utility).async {
			if let url = URL(string: imageURL), let imageData = try? Data(contentsOf: url) {
				let image = UIImage(data: imageData)
				DispatchQueue.main.async {
					if animateOnFirstLoad {
						self.setImageWithTransition(image, transition: transition)
					}
					else {
						self.image = image
					}
				}
			}
		}
	}
	
}
