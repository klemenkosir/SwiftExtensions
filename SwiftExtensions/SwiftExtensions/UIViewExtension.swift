//
//  UIViewExtensions.swift
//  
//
//  Created by Klemen Kosir on 23/01/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

public enum UIViewAddAnimation {
	case fade
	case none
}

private var viewIdentifierKey: UInt8 = 0
private var drawDottedLineKey: UInt8 = 0
private var isShimmeringKey: UInt8 = 0
private var gradientStartColorKey: UInt8 = 0
private var gradientEndColorKey: UInt8 = 0

public extension UIView {
	
	@IBInspectable var identifier: String? {
		get {
			return objc_getAssociatedObject(self, &viewIdentifierKey) as? String
		}
		set(newValue) {
			if let nv = newValue {
				objc_setAssociatedObject(self, &viewIdentifierKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}
	
	@IBInspectable var allowsEdgeAntialiasing: Bool {
		get {
			return layer.allowsEdgeAntialiasing
		}
		set {
			layer.allowsEdgeAntialiasing = newValue
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return self.layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor {
		get {
			if let bc = layer.borderColor {
				return UIColor(cgColor: bc)
			}
			return UIColor.clear
		}
		set {
			layer.borderColor = newValue.cgColor
		}
	}
	
	@IBInspectable var clipToBounds: Bool {
		get {
			return self.clipsToBounds
		}
		set {
			self.clipsToBounds = newValue
		}
	}
	
	@IBInspectable var shadowOffset: CGSize {
		get {
			return self.layer.shadowOffset
		}
		set {
			self.layer.shadowOffset = newValue
		}
	}
	
	@IBInspectable var shadowColor: UIColor {
		get {
			return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
		}
		set {
			self.layer.shadowColor = newValue.cgColor
		}
	}
	
	@IBInspectable var shadowRadius: CGFloat {
		get {
			return self.layer.shadowRadius
		}
		set {
			self.layer.shadowRadius = newValue
		}
	}
	
	@IBInspectable var shadowOpacity: Float {
		get {
			return self.layer.shadowOpacity
		}
		set {
			self.layer.shadowOpacity = newValue
		}
	}
	
	@IBInspectable var isShimmering: Bool {
		get {
			return (objc_getAssociatedObject(self, &isShimmeringKey) as? NSNumber)?.boolValue ?? false
		}
		set(newValue) {
			let nv = NSNumber(value: newValue)
			objc_setAssociatedObject(self, &isShimmeringKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
    
    @IBInspectable var gradientStartColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &gradientStartColorKey) as? UIColor
        }
        set(newValue) {
            if let nv = newValue {
                objc_setAssociatedObject(self, &gradientStartColorKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                initGradient()
            }
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &gradientEndColorKey) as? UIColor
        }
        set(newValue) {
            if let nv = newValue {
                objc_setAssociatedObject(self, &gradientEndColorKey, nv, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                initGradient()
            }
        }
    }
	
	
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
	
	func addSubviewFromViewController(_ vc: UIViewController) {
		self.addSubviewFromViewController(vc, useAutoLayout: false)
	}
	
	func addSubviewFromViewController(_ vc: UIViewController, useAutoLayout: Bool, addConstraints: Bool = true) {
		//		self.superview?.layoutIfNeeded()
        self.parentViewController?.addChild(vc)
		vc.view.frame = self.bounds
		self.addSubview(vc.view)
        vc.didMove(toParent: self.parentViewController)
		
		if useAutoLayout {
			vc.view.translatesAutoresizingMaskIntoConstraints = false
			if !addConstraints {
				return
			}
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vcView]|", metrics: nil, views: ["vcView": vc.view]))
			self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vcView]|", metrics: nil, views: ["vcView": vc.view]))
			self.layoutIfNeeded()
		}
	}
	
	func addSubviewFromViewController(_ vc: UIViewController, useAutoLayout: Bool, animation: UIViewAddAnimation) {
		vc.view.alpha = 0.0
		self.addSubviewFromViewController(vc, useAutoLayout: useAutoLayout)
		switch animation {
		case .fade:
			UIView.animate(withDuration: 0.1, animations: {
				vc.view.alpha = 1.0
			})
		default:
			vc.view.alpha = 1.0
			break
		}
	}
	
	func addSubviewWithAutolayout(_ view: UIView) {
		self.addSubview(view)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", metrics: nil, views: ["view": view]))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", metrics: nil, views: ["view": view]))
		self.layoutIfNeeded()
		
	}
	
	func addSubviewFromViewControllerWithOfset(_ vc: UIViewController, offset: CGPoint) {
        self.parentViewController?.addChild(vc)
		vc.view.frame = self.bounds.offsetBy(dx: offset.x, dy: offset.y)
		self.addSubview(vc.view)
        vc.didMove(toParent: self.parentViewController)
	}
	
	func addSubviewFromViewControllerWithFrame(_ vc: UIViewController, frame: CGRect) {
        self.parentViewController?.addChild(vc)
		vc.view.frame =  frame
		self.addSubview(vc.view)
        vc.didMove(toParent: self.parentViewController)
	}
	
	func removeAllGestureRecognizers() {
		if let gr = self.gestureRecognizers {
			for gesture in gr {
				self.removeGestureRecognizer(gesture)
			}
		}
	}
	
	func removeAllSubviews() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
	}
	
	func removeAllConstraints() {
		self.removeConstraints(self.constraints)
	}
	
	func round(_ corners: UIRectCorner, radius: CGFloat) {
		if self.translatesAutoresizingMaskIntoConstraints == false {
			self.layoutIfNeeded()
		}
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		self.layer.mask = mask
	}
	
	func currentFirstResponder() -> UIResponder? {
		if self.isFirstResponder {
			return self
		}
		
		for view in self.subviews {
			if let responder = view.currentFirstResponder() {
				return responder
			}
		}
		return nil
	}
	
	func constraints(enabled: Bool) {
		for constraint in self.constraints {
			constraint.isActive = enabled
		}
	}
	
	func constraints(withIdentifier identifier: String) -> [NSLayoutConstraint] {
		var foundConstraints = [NSLayoutConstraint]()
		
		for constraint in self.constraints {
			if constraint.identifier == identifier {
				foundConstraints.append(constraint)
			}
		}
		
		for constraint in self.superview?.constraints ?? [] {
			if constraint.identifier == identifier && (constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self) {
				foundConstraints.append(constraint)
			}
		}
		
		return foundConstraints
	}
	
	var zPosition: CGFloat {
		get {
			return self.layer.zPosition
		}
		set(newValue) {
			self.layer.zPosition = newValue
		}
	}
	
	func drawDottedLine(_ color: UIColor?) {
		for sublayer in self.layer.sublayers ?? [] {
			sublayer.removeFromSuperlayer()
		}
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0.25, y: 0.25))
		path.addLine(to: CGPoint(x: 0.25, y: self.frame.size.height-0.25))
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		shapeLayer.strokeColor = color?.cgColor ?? self.backgroundColor?.cgColor ?? UIColor.black.cgColor
		self.backgroundColor = .clear
		shapeLayer.lineWidth = 0.5
		shapeLayer.lineDashPattern = [NSNumber(value: 0.5 as Float), NSNumber(value: 0.5 as Float)]
		self.layer.addSublayer(shapeLayer)
	}
	
	func startShimmering(duration: Float = 1.5) {
		if isShimmering {
			return
		}
		let light = UIColor(white: 0.0, alpha: 0.6).cgColor
		let dark = UIColor.black.cgColor
		
		let gradient = CAGradientLayer()
		gradient.colors = [dark, light, dark]
		gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3*self.bounds.size.width, height: self.bounds.size.height)
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradient.locations = [0.0, 0.2, 0.4]
		self.layer.mask = gradient
		
		let animation = CABasicAnimation(keyPath: "locations")
		animation.fromValue = [0.0, 0.2, 0.4]
		animation.toValue = [0.6, 0.8, 1.0]
		animation.duration = CFTimeInterval(duration)
		animation.repeatCount = Float.greatestFiniteMagnitude
		gradient.add(animation, forKey: "shimmer")
		
	}
	
	func stopShimmering() {
		self.layer.mask = nil
	}
    
    func initGradient() {
        guard let startColor = gradientStartColor,
            let endColor = gradientEndColor else {
                return
        }
        
        self.layer.sublayers?.forEach({ (sublayer) in
            if sublayer.name == "gradient" {
                sublayer.removeFromSuperlayer()
            }
        })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradient"
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
