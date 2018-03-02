//
//  MonthDataSource.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

// Constants
private let kDaysPerWeek = 7
private let kNumberOfVisibleWeeks = 7 // 6 - rows with numbers + 1 - with titles
private let kExpectedNumberOfItems = kDaysPerWeek * kNumberOfVisibleWeeks

class DataProvider : NSObject, MonthCollectionViewControllerDataSource, MonthsListViewControllerDelegate, MonthsListViewControllerDataSource {

	private var currentDate : Date
	private var dayValues = [Day]()
	
	// MARK: - Properties
	init(date currentDate: Date) {
		self.currentDate = currentDate
	}
	
	// MARK: - Internal methods
	
	func reloadData() {
		dayValues = []
		
		let calendar = Calendar.current
		
		// Making "monday" as the first day of a week
		var weekTitles = calendar.veryShortWeekdaySymbols
		let title = weekTitles.remove(at:0)
		weekTitles.append(title)
		
		for title in weekTitles {
			let day = Day(dayType: .weekTitle, title: title)
			dayValues.append(day)
		}
		
		// Adding days from previous month to fill first row
		var dateComponent = calendar.dateComponents(
					[.year, .month, .day, .hour], from: currentDate)
		dateComponent.day = 1
		if let firstDayOfMonth = calendar.date(from: dateComponent) {
			let weekday = calendar.component(.weekday, from: firstDayOfMonth)
			var daysNumberShouldBeAdded = (weekday + kDaysPerWeek - 2) % kDaysPerWeek
			dateComponent = DateComponents()
			while daysNumberShouldBeAdded > 0 {
				dateComponent.day = -daysNumberShouldBeAdded
				
				if let tempDate = calendar.date(byAdding: dateComponent, to: firstDayOfMonth) {
					var component = calendar.dateComponents(
								[.year, .month, .day, .hour], from: tempDate)
					if let dayValue = component.day {
						let day = Day(dayType: .anotherMonth, title: String(dayValue))
						dayValues.append(day)
					}
				}
				daysNumberShouldBeAdded -= 1
			}
		}

		// Adding days from current month
		dateComponent = calendar.dateComponents(
					[.year, .month, .day, .hour], from: currentDate)
		for dayValue in CountableRange(calendar.range(of: .day, in: .month, for: currentDate)!) {
			dateComponent.day = dayValue
			if let iterationDate = calendar.date(from: dateComponent) {
				let weekdayIndex = calendar.component(.weekday, from: iterationDate)
				let day = Day(dayType: Day.dayTypeForWeekdayIndex(weekdayIndex), title: String(dayValue))
				dayValues.append(day)
			}
		}
		
		// Adding days from next month to last items
		dateComponent = calendar.dateComponents(
					[.year, .month, .day, .hour], from: currentDate)
		dateComponent.day = calendar.range(of: .day, in: .month, for: currentDate)?.count
		if let lastDayOfMonth = calendar.date(from: dateComponent) {
			let daysNumberShouldBeAdded = kExpectedNumberOfItems - dayValues.count
			var dayIndex = 1
			dateComponent = DateComponents()
			while daysNumberShouldBeAdded >= dayIndex {
				dateComponent.day = dayIndex
				
				if let tempDate = calendar.date(byAdding: dateComponent, to: lastDayOfMonth) {
					var component = calendar.dateComponents(
						[.year, .month, .day, .hour], from: tempDate)
					if let dayValue = component.day {
						let day = Day(dayType: .anotherMonth, title: String(dayValue))
						dayValues.append(day)
					}
				}
				dayIndex += 1
			}
		}
	}
	
	func indexFromIndexPath(_ indexPath: IndexPath) -> Int {
		return indexPath.section * kDaysPerWeek + indexPath.row
	}
	
	// MARK: - MonthCollectionViewControllerDataSource methods

	func numberOfVisibleWeeks() -> Int {
		return kNumberOfVisibleWeeks
	}
	
	func numberOfDaysInWeek(_ week: Int) -> Int {
		return kDaysPerWeek
	}
	
	func dayAt(_ indexPath: IndexPath) -> Day? {
		let index = indexFromIndexPath(indexPath)
		return kExpectedNumberOfItems > index ? dayValues[index] : nil
	}

	func shouldSelectDayAt(_ indexPath: IndexPath) -> Bool
	{
		let index = indexFromIndexPath(indexPath)
		let day = dayValues[index]
		return day.dayType == .weekend || day.dayType == .workday
	}

	// MARK: - MonthsListViewControllerDataSource methods

	func selectedMonth() -> Int {
		return 0
	}
	
	// MARK: - MonthsListViewControllerDelegate methods
	
	func monthDidSelectedAt(_ indexPath: IndexPath) {
		print(indexPath)
	}
	
}
