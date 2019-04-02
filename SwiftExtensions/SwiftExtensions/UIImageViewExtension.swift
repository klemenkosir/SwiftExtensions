//
//  UIImageViewExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 17. 12. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import Foundation

public extension UIImageView {
	
	enum ScalingFilters: Int {
		case linear
		case nearest
		case trilinear
		
		static func fromContentsFilter(_ filter: CALayerContentsFilter) -> Int {
			switch filter {
			case .linear:
				return 0
			case .nearest:
				return 1
			case .trilinear:
				return 2
			default:
				return 0
			}
		}
		
		func toContentsFilter() -> CALayerContentsFilter {
			switch self {
			case .linear:
                return .linear
			case .nearest:
                return .nearest
			case .trilinear:
                return .trilinear
			}
		}
	}
	
	@IBInspectable var miniFilter: Int {
		get {
            return ScalingFilters.fromContentsFilter(self.layer.minificationFilter)
		}
		set {
			self.layer.minificationFilter = ScalingFilters(rawValue: newValue)?.toContentsFilter() ?? .linear
		}
	}
	
	@IBInspectable var magFilter: Int {
		get {
			return ScalingFilters.fromContentsFilter(self.layer.magnificationFilter)
		}
		set {
			self.layer.magnificationFilter = ScalingFilters(rawValue: newValue)?.toContentsFilter() ?? .linear
		}
	}
	
    func setImageWithTransition(_ image: UIImage?, transition: UIView.AnimationOptions) {
		DispatchQueue.main.async { () -> Void in
			UIView.transition(with: self, duration: 0.2, options: transition, animations: { () -> Void in
				self.image = image
			}) { (completed) -> Void in
				
			}
		}
	}
	
    func setImageWithTransition(_ image: UIImage?, duration: Double, transition: UIView.AnimationOptions) {
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
	
    func getImage(_ imageURL: String?, animateOnFirstLoad: Bool, transition: UIView.AnimationOptions) {
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
