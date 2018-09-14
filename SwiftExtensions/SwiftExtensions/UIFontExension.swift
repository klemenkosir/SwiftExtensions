//
//  UIFontExension.swift
//  
//
//  Created by Klemen Kosir on 21/04/16.
//  Copyright © 2016 Klemen Košir. All rights reserved.
//

import UIKit

public enum SystemFontWeight : String {
	case UltraLight = "HelveticaNeue-UltraLight"
	case Thin = "HelveticaNeue-Thin"
	case Light = "HelveticaNeue-Light"
	case Regular = "HelveticaNeue"
	case Medium = "HelveticaNeue-Medium"
	case Semibold = "Helvetica-Bold"
	case Bold = "HelveticaNeue-Bold"
	case Heavy = "HelveticaNeue-CondensedBold"
	case Black = "HelveticaNeue-CondensedBlack"
	
	var weightValue:CGFloat? {
		if #available(iOS 8.2, *) {
			switch self {
			case .UltraLight:
				return UIFontWeightUltraLight
			case .Thin:
				return UIFontWeightThin
			case .Light:
				return UIFontWeightLight
			case .Regular:
				return UIFontWeightRegular
			case .Medium:
				return UIFontWeightMedium
			case .Semibold:
				return UIFontWeightSemibold
			case .Bold:
				return UIFontWeightBold
			case .Heavy:
				return UIFontWeightHeavy
			case .Black:
				return UIFontWeightBlack
			}
		} else {
			return nil
		}
	}
}

public extension UIFont {
	static func systemFontOfSize(_ fontSize:CGFloat, weight:SystemFontWeight) -> UIFont {
		if #available(iOS 8.2, *) {
			return UIFont.systemFont(ofSize: fontSize, weight: weight.weightValue!)
			
		} else {
			// Fallback on earlier versions
			return UIFont.init(name: weight.rawValue, size: fontSize)!
		}
	}
}
