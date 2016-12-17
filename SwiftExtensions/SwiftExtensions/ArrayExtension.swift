//
//  ArrayExtension.swift
//  
//
//  Created by Klemen Kosir on 25/04/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

public extension Array {
	
	mutating func removeObject<T: Equatable>(_ object: T) -> Bool {
		for (idx, objectToCompare) in self.enumerated() {
			if let to = objectToCompare as? T {
				if object == to {
					self.remove(at: idx)
					return true
				}
			}
		}
		return false
	}
	
}

public extension Array where Element : Equatable {
	
	func unique() -> [Element] {
		var uniqueValues: [Element] = []
		forEach { item in
			if !uniqueValues.contains(item) {
				uniqueValues += [item]
			}
		}
		return uniqueValues
	}
	
	mutating func appendOptional(_ element: Element?) {
		if let el = element {
			self.append(el)
		}
	}
}
