//
//  MonthCollectionViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

enum DayType {
	case weekTitle
	case anotherMonth
	case weekend
	case workday
}

protocol MonthCollectionViewControllerDataSource : AnyObject {

	func numberOfVisibleWeeks() -> Int
	func numberOfDaysInWeek(_ week: Int) -> Int

}

class MonthCollectionViewController : UICollectionViewController {
	
	//  Constants
	private let kWorkingDayCellKey = "WorkingDayViewCell"

	// MARK: - Properties

	weak var dataSource : MonthCollectionViewControllerDataSource!
	
	// MARK: - Collection View methods

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSource != nil ? dataSource.numberOfVisibleWeeks() : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource != nil ? dataSource.numberOfDaysInWeek(section) : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: kWorkingDayCellKey, for: indexPath)
	}
	
	
	
}
