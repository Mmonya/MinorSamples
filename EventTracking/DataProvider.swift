//
//  MonthDataSource.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

// Global constants
let kMonthDidChangeNotificationName = Notification.Name(rawValue: "kMonthDidChangeNotificationName")
let kOldDateUserInfoKey = "kOldDateUserInfoKey"

// Private constants
private let kDaysPerWeek = 7
private let kNumberOfVisibleWeeks = 7 // 6 - rows with numbers + 1 - with titles
private let kExpectedNumberOfItems = kDaysPerWeek * kNumberOfVisibleWeeks

class DataProvider : NSObject, MonthCollectionViewControllerDataSource,
			MonthCollectionViewControllerDelegate,
			MonthsListViewControllerDataSource, MonthsListViewControllerDelegate {

	private var currentDate : Date
	private var dayValues = [Day]()
	private var selectedDayIndex = -1
	
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
		
		// Adding days from the previous month to fill first row
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

		// Adding days from the current month
		dateComponent = calendar.dateComponents(
					[.year, .month, .day, .hour], from: currentDate)
		let currentDayValue = dateComponent.day!
		for dayValue in CountableRange(calendar.range(of: .day, in: .month, for: currentDate)!) {
			dateComponent.day = dayValue
			if let iterationDate = calendar.date(from: dateComponent) {
				let weekdayIndex = calendar.component(.weekday, from: iterationDate)
				let day = Day(dayType: Day.dayTypeForWeekdayIndex(weekdayIndex), title: String(dayValue))
				day.value = dayValue
				dayValues.append(day)
				if dayValue == currentDayValue {
					selectedDayIndex = dayValues.count - 1
				}
			}
		}
		
		// Adding days from the next month to fill last items
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
	
	func indexPathFromIndex(_ index: Int) -> IndexPath {
		return IndexPath(row: index % kDaysPerWeek, section: index / kDaysPerWeek)
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
	
	func selectedDayIndexPath() -> IndexPath {
		return indexPathFromIndex(selectedDayIndex)
	}

	// MARK: - MonthCollectionViewControllerDataSource methods
	
	func monthCollectionDidSelectDayAt(_ indexPath: IndexPath) {
		if let dayValue = dayAt(indexPath)?.value {
			let calendar = Calendar.current
			var dateComponent = calendar.dateComponents(
						[.year, .month, .day, .hour], from: currentDate)
			dateComponent.day = dayValue
			if let newDate = calendar.date(from: dateComponent) {
				currentDate = newDate
				selectedDayIndex = indexFromIndexPath(indexPath)
			}
		}
	}

	// MARK: - MonthsListViewControllerDataSource methods

	func selectedMonthIndex() -> Int {
		let calendar = Calendar.current
		let dateComponent = calendar.dateComponents(
					[.year, .month, .day, .hour], from: currentDate)
		return dateComponent.month != nil ? dateComponent.month! - 1 : 0
	}
	
	// MARK: - MonthsListViewControllerDelegate methods
	
	func monthsListDidSelectMonthAt(_ indexPath: IndexPath) {
		let calendar = Calendar.current
		var dateComponent = calendar.dateComponents(
			[.year, .month, .day, .hour], from: currentDate)
		if let currentMonth = dateComponent.month {
			if currentMonth != indexPath.row + 1 {
				dateComponent = DateComponents()
				dateComponent.month = indexPath.row + 1 - currentMonth
				if let newDate = calendar.date(byAdding: dateComponent, to: currentDate) {
					let oldDate = currentDate
					currentDate = newDate
					
					reloadData()
					NotificationCenter.default.post(name: kMonthDidChangeNotificationName, object: self, userInfo: [kOldDateUserInfoKey: oldDate])
				}
			}
		}
	}
	
}
