//
//  MonthDataSource.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

class DaysDataProvider : NSObject, MonthCollectionViewControllerDataSource {

	//  Constants
	private let kDaysPerWeek = 7
	private let kNumberOfVisibleWeeks = 6

	// MARK: - MonthCollectionViewControllerDataSource methods

	func numberOfVisibleWeeks() -> Int {
		return kNumberOfVisibleWeeks
	}
	
	func numberOfDaysInWeek(_ week: Int) -> Int {
		return kDaysPerWeek
	}

}
