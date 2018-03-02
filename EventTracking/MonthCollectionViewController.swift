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
	func dayAt(_ indexPath: IndexPath) -> Day?
	func shouldSelectDayAt(_ indexPath: IndexPath) -> Bool
	
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
		cellColors.append(UIColor.init(white: 0.9, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0.45, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0, alpha: 1.0))
	}
	
	override func viewDidAppear(_ animated: Bool) {

	}
	
	func cellColorForDayType(_ dayType: DayType) -> UIColor {
		var index = 0
		switch dayType {
			case .weekTitle, .anotherMonth, .weekend, .workday:
				index = dayType.rawValue
		}
		return cellColors[index]
	}
	
	func setup(viewCell: DayCollectionViewCell, forDay day: Day) {
		viewCell.titleLabel.textColor = cellColorForDayType(day.dayType)
		viewCell.titleLabel.text = day.title
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
		if let day = dataSource.dayAt(indexPath) {
			setup(viewCell: cell, forDay: day)
		}
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		let result = dataSource.shouldSelectDayAt(indexPath)
		print("shouldHighlightItemAt (\(result)) = \(indexPath)")
		return result
	}
	
	override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		print("didHighlightItemAt = \(indexPath)")
	}
	
	override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		print("didUnhighlightItemAt = \(indexPath)")
	}
	
	var shouldDeselect = false
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let result = dataSource.shouldSelectDayAt(indexPath)
		print("shouldSelectItemAt (\(result)) = \(indexPath)")
		shouldDeselect = result
		return result
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		shouldDeselect = false
		print("didSelectItemAt = \(indexPath)")
		print("-----------------------------------------")
		
		
		// Send information
		
		
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		print("shouldDeselectItemAt = \(indexPath)")
		return true
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		print("didDeselectItemAt = \(indexPath)")
		if !shouldDeselect {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition:
				UICollectionViewScrollPosition())
		}
		shouldDeselect = false
	}
}
