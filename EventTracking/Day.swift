//
//  Day.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/28/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

enum DayType : Int {
	case weekTitle
	case anotherMonth
	case weekend
	case workday
}

class Day {
	
	let dayType : DayType
	let title : String
	var value : Int?
	
	init(dayType : DayType, title : String) {
		self.dayType = dayType
		self.title = title
	}
	
	static func dayTypeForWeekdayIndex(_ index: Int) -> DayType {
		return 1 == index || index == 7 ? .weekend : .workday
	}
	
}
