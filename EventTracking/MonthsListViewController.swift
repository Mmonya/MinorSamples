//
//  MonthsListViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/2/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Protocols declaretion
protocol MonthsListViewControllerDataSource : AnyObject {
	func selectedMonthIndex() -> Int
}

protocol MonthsListViewControllerDelegate : AnyObject {
	func monthsListDidSelectMonthAt(_ indexPath: IndexPath)
}

class MonthsListViewController : UITableViewController {
	
	// MARK: - Properties
	
	weak var delegate : MonthsListViewControllerDelegate?
	weak var dataSource : MonthsListViewControllerDataSource?
	
	//  MARK: - Internal methods

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateSelectedItem()
	}
	
	func updateSelectedItem() {
		if let selectedMonthIndex = dataSource?.selectedMonthIndex() {
			let indexPath = IndexPath(row: selectedMonthIndex, section: 0)
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
		}
	}
	
	// MARK: - TableViews methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.monthsListDidSelectMonthAt(indexPath)
	}
	
}
