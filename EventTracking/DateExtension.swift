//
//  NSDateExtension.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/9/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

extension Date {
	var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}
	
	var endOfDay: Date {
		var dateComponent = DateComponents()
		dateComponent.day = 1
		dateComponent.second = -1
		return Calendar.current.date(byAdding: dateComponent, to: startOfDay) ?? self
	}
}
