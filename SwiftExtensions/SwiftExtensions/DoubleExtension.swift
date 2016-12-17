//
//  DoubleExtension.swift
//  SwiftExtensions
//
//  Created by Klemen Kosir on 17. 12. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import Foundation


public extension Double {
	
	var degreesToRadians : Double {
		return self * M_PI / 180.0
	}
	
	var radiansToDegrees : Double {
		return self * 180.0 / M_PI
	}
	
}
