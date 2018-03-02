//
//  MonthsListViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/2/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

protocol MonthsListViewControllerDataSource : AnyObject {
	func selectedMonth() -> Int
}

protocol MonthsListViewControllerDelegate : AnyObject {
	func monthDidSelectedAt(_ indexPath: IndexPath)
}

class MonthsListViewController : UITableViewController {
	
	var delegate : MonthsListViewControllerDelegate?
	var dataSource : MonthsListViewControllerDataSource?
	
	override func viewDidAppear(_ animated: Bool) {
		updateSelectedItem()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.monthDidSelectedAt(indexPath)
	}
	
	func updateSelectedItem() {
		if let selectedMonth = dataSource?.selectedMonth() {
			let indexPath = IndexPath(row: selectedMonth, section: 0)
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
		}
	}
	
}
