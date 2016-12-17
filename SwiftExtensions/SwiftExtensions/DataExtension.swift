//
//  DataExtension.swift
//
//
//  Created by Klemen Kosir on 24. 10. 16.
//  Copyright © 2016 Klemen Kosir. All rights reserved.
//

import Foundation

public extension Data {
	
	var hexString: String {
		return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
	}
	
}
