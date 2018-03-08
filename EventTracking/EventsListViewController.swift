//
//  EventsListViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/8/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Constants
private let kEventViewCellIdentifier = "EventViewCell"

// Protocols declaretion
protocol EventsListViewControllerDataSource : AnyObject {
	
	func numberOfEvents() -> Int
	func eventItemAt(_ indexPath: IndexPath) -> EventItem?
	
}

//protocol EventsListViewControllerDelegate : AnyObject {
//	
//}

class EventsListViewController: UITableViewController {
	
	// MARK: - Properties
	
	weak var dataSource : EventsListViewControllerDataSource!
	
	// MARK: - Internal methods

	override func viewDidLoad() {
		super.viewDidLoad()
		if let parent = self.parent {
			let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
			parent.navigationItem.rightBarButtonItem = addButton
			parent.title = NSLocalizedString("All Events", comment: "")
		}
	}
	
	func insertNewObject(_ sender: Any) {
		
	}
	
	func setup(_ viewCell: UITableViewCell, for eventItem: EventItem) {
		viewCell.textLabel?.text = eventItem.title
		viewCell.detailTextLabel?.text = eventItem.subtitle
	}
	
	// MARK: - TableViews methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource != nil ? dataSource.numberOfEvents() : 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let viewCell = tableView.dequeueReusableCell(withIdentifier: kEventViewCellIdentifier, for: indexPath)
		if let eventItem = dataSource.eventItemAt(indexPath) {
			setup(viewCell, for: eventItem)
		}
		return viewCell
	}
	
}
