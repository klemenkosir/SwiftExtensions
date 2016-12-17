//
//  CGRectExtension.swift
//  
//
//  Created by Klemen Kosir on 25/04/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

public extension CGRect {
	
	var end: CGPoint {
		return CGPoint(x: self.origin.x + self.size.width, y: self.origin.y + self.size.height)
	}
	
	var center: CGPoint {
		return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height/2)
	}
	
}
