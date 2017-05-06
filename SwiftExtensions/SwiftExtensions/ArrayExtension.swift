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
	
	func shift(withDistance distance: Int = 1) -> Array<Element> {
		let offsetIndex = distance >= 0 ?
			self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
			self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
		
		guard let index = offsetIndex else { return self }
		return Array(self[index ..< endIndex] + self[startIndex ..< index])
	}
	
	mutating func shiftInPlace(withDistance distance: Int = 1) {
		self = shift(withDistance: distance)
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
