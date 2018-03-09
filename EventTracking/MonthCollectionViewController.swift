//
//  MonthCollectionViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Constants
private let kWorkingDayCellKey = "WorkingDayViewCell"

// Protocols declaretion
protocol MonthCollectionViewControllerDataSource : AnyObject {

	func numberOfVisibleWeeks() -> Int
	func numberOfDaysInWeek(_ week: Int) -> Int
	func dayAt(_ indexPath: IndexPath) -> Day?
	func shouldSelectDayAt(_ indexPath: IndexPath) -> Bool
	func selectedDayIndexPath() -> IndexPath
	
}

protocol MonthCollectionViewControllerDelegate : AnyObject {
	
	func monthCollectionDidSelectDayAt(_ indexPath: IndexPath)
	
}

class MonthCollectionViewController : UICollectionViewController {
	
	// MARK: - Properties

	weak var dataSource : MonthCollectionViewControllerDataSource! {
		willSet {
			NotificationCenter.default.removeObserver(self,
						name: kMonthDidChangeNotificationName, object: dataSource)
		}
		didSet {
			NotificationCenter.default.addObserver(self, selector:
						#selector(monthDidChangeValue), name:
						kMonthDidChangeNotificationName, object: dataSource)
		}
	}
	weak var delegate : MonthCollectionViewControllerDelegate?
	private var cellColors : [UIColor] = []
	private var shouldDeselectItem = false

	// MARK: - Internal methods
	deinit {
		NotificationCenter.default.removeObserver(self,
					name: kMonthDidChangeNotificationName, object: dataSource)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cellColors.append(UIColor.init(white: 0.8, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0.9, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0.45, alpha: 1.0))
		cellColors.append(UIColor.init(white: 0, alpha: 1.0))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateSelectedItem()
	}
	
	func cellColorForDayType(_ dayType: DayType) -> UIColor {
		var index = 0
		switch dayType {
			case .weekTitle, .anotherMonth, .weekend, .workday:
				index = dayType.rawValue
		}
		return cellColors[index]
	}
	
	func setup(_ viewCell: DayCollectionViewCell, for day: Day) {
		viewCell.titleLabel.textColor = cellColorForDayType(day.dayType)
		viewCell.titleLabel.text = day.title
	}
	
	func updateSelectedItem() {
		for indexPath in collectionView?.indexPathsForSelectedItems ?? [] {
			collectionView?.deselectItem(at: indexPath, animated: false)
		}
		collectionView?.selectItem(at: dataSource?.selectedDayIndexPath(),
					animated: false, scrollPosition:UICollectionViewScrollPosition())
	}
	
	func monthDidChangeValue(_ notification: Notification) {
		collectionView?.reloadData()
		shouldDeselectItem = false
		updateSelectedItem()
	}
	
	// MARK: - Collection View methods

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSource != nil ? dataSource.numberOfVisibleWeeks() : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource != nil ? dataSource.numberOfDaysInWeek(section) : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let viewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kWorkingDayCellKey, for: indexPath) as! DayCollectionViewCell
		if let day = dataSource.dayAt(indexPath) {
			setup(viewCell, for: day)
		}
		return viewCell
	}

	override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		let result = dataSource.shouldSelectDayAt(indexPath)
		return result
	}
	
	override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let result = dataSource.shouldSelectDayAt(indexPath)
		shouldDeselectItem = result
		return result
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		shouldDeselectItem = false
		delegate?.monthCollectionDidSelectDayAt(indexPath)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if !shouldDeselectItem {
			updateSelectedItem()
		}
		shouldDeselectItem = false
	}
}
