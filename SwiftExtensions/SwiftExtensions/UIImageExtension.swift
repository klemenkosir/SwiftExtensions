//
//  UIImageExtension.swift
//
//
//  Created by Klemen Kosir on 06/02/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

public extension UIImage {
	
	func resize(_ newWidth: CGFloat, resizeIfSmaller: Bool = false) -> UIImage {
		if self.size.width <= newWidth && !resizeIfSmaller {
			return self
		}
		let scale = newWidth / self.size.width
		let newHeight = self.size.height * scale
		UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
		self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	func crop(toRect rect:CGRect) -> UIImage? {
		var scaledRec = rect
		scaledRec.origin.x *= self.scale
		scaledRec.origin.y *= self.scale
		scaledRec.size.width *= self.scale
		scaledRec.size.height *= self.scale
		let cgImage = self.fixOrientation().cgImage
		if let imageRef = cgImage?.cropping(to: scaledRec) {
			return UIImage(cgImage: imageRef)
		}
		else {
			return nil
		}
	}
	
	func fixOrientation() -> UIImage {
		
		if self.imageOrientation == UIImageOrientation.up {
			return self
		}
		
		var transform = CGAffineTransform.identity
		
		switch self.imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: self.size.width, y: self.size.height)
			transform = transform.rotated(by: CGFloat(M_PI));
			
		case .left, .leftMirrored:
			transform = transform.translatedBy(x: self.size.width, y: 0);
			transform = transform.rotated(by: CGFloat(M_PI_2));
			
		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: self.size.height);
			transform = transform.rotated(by: CGFloat(-M_PI_2));
			
		case .up, .upMirrored:
			break
		}
		
		
		switch self.imageOrientation {
			
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: self.size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
			
		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: self.size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1);
			
		default:
			break;
		}
		
		
		// Now we draw the underlying CGImage into a new context, applying the transform
		// calculated above.
		let ctx = CGContext(
			data: nil,
			width: Int(self.size.width),
			height: Int(self.size.height),
			bitsPerComponent: (self.cgImage?.bitsPerComponent)!,
			bytesPerRow: 0,
			space: (self.cgImage?.colorSpace!)!,
			bitmapInfo: UInt32((self.cgImage?.bitmapInfo.rawValue)!)
		)
		
		ctx?.concatenate(transform);
		
		switch self.imageOrientation {
			
		case .left, .leftMirrored, .right, .rightMirrored:
			// Grr...
			ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height,height: self.size.width));
			
		default:
			ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width,height: self.size.height));
			break;
		}
		
		// And now we just create a new UIImage from the drawing context
		let cgimg = ctx?.makeImage()
		
		let img = UIImage(cgImage: cgimg!)
		
		//CGContextRelease(ctx);
		//CGImageRelease(cgimg);
		
		return img;
		
	}
	
}
