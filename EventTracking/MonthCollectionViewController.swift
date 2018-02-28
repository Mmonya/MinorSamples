//
//  MonthCollectionViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

protocol MonthCollectionViewControllerDataSource : AnyObject {

	func numberOfVisibleWeeks() -> Int
	func numberOfDaysInWeek(_ week: Int) -> Int
	func dayAt(_ indexPath: IndexPath) -> Day
	
}

// Constants
private let kWorkingDayCellKey = "WorkingDayViewCell"

class MonthCollectionViewController : UICollectionViewController {
	
	// MARK: - Properties

	weak var dataSource : MonthCollectionViewControllerDataSource!
	var cellColors : [UIColor] = []
	
	// MARK: - Internal methods

	override func viewDidLoad() {
		cellColors.append(UIColor.init(white: 0.8, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0.8, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0.4, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0, alpha: 1.0))
	}
	
	func cellColorForDayType(_ dayType: DayType) -> UIColor {
		var index = 0
		switch dayType {
			case .weekTitle, .anotherMonth, .weekend, .workday:
				index = dayType.rawValue
		}
		return cellColors[index]
	}
	
	// MARK: - Collection View methods

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSource != nil ? dataSource.numberOfVisibleWeeks() : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource != nil ? dataSource.numberOfDaysInWeek(section) : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWorkingDayCellKey, for: indexPath) as! DayCollectionViewCell
		let day = dataSource.dayAt(indexPath)
		cell.titleLabel.textColor = cellColorForDayType(day.dayType)
		cell.titleLabel.text = day.title
		return cell
	}
	
	
	
}
