//
//  MonthsListViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/2/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

protocol MonthsListViewControllerDataSource : AnyObject {
	func selectedMonthIndex() -> Int
}

protocol MonthsListViewControllerDelegate : AnyObject {
	func monthsListDidSelectMonthAt(_ indexPath: IndexPath)
}

class MonthsListViewController : UITableViewController {
	
	weak var delegate : MonthsListViewControllerDelegate?
	weak var dataSource : MonthsListViewControllerDataSource?
	
	override func viewDidAppear(_ animated: Bool) {
		updateSelectedItem()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.monthsListDidSelectMonthAt(indexPath)
	}
	
	func updateSelectedItem() {
		if let selectedMonthIndex = dataSource?.selectedMonthIndex() {
			let indexPath = IndexPath(row: selectedMonthIndex, section: 0)
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
		}
	}
	
}
