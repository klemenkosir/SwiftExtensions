//
//  StringExtension.swift
//  
//
//  Created by Klemen Kosir on 02/06/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import Foundation

public extension String {
	
	func deleteHTMLTag(_ tag:String) -> String {
		return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
	}
	
	func deleteHTMLTags(_ tags:[String]) -> String {
		var mutableString = self
		for tag in tags {
			mutableString = mutableString.deleteHTMLTag(tag)
		}
		return mutableString
	}
	
	func deleteAllHTMLTags() -> String {
		return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
	}
	
	var length: Int {
		return self.characters.count
	}
	
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
	func isValidPhoneNumber() -> Bool {
		let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
		let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
		return phoneTest.evaluate(with: self)
	}
	
	var URLString: String {
		var string = self
		if !string.contains("http://") && !string.contains("https://") {
			string = "http://" + string
		}
		return string
	}
	
	init(htmlEncodedString: String?) throws {
		self.init()
		guard let htmlEncodedString = htmlEncodedString, let encodedData = htmlEncodedString.data(using: String.Encoding.utf8) else {
			return
		}
		let attributedOptions: [String: Any] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
		let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
		self = attributedString.string
	}
	
}

//public extension CustomStringConvertible {
//	var stringValue: String {
//		return "\(self)"
//	}
//}
