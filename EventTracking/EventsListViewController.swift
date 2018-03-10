//
//  EventsListViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/8/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Private constants
private let kAddNewEventSegueIdentifier = "AddNewEvent"
private let kChangeEventSegueIdentifier = "ChangeEvent"
private let kEventViewCellIdentifier = "EventViewCell"

enum ReloadDataStatus : Int {
	
	case success
	case accessRestricted
	case undefined
	
}

// Protocols declaretion
protocol EventsListViewControllerDataSource : AnyObject {
	
	func reloadData(completion: @escaping (ReloadDataStatus) -> ())
	
	func numberOfEvents() -> Int
	func eventItemAt(_ indexPath: IndexPath) -> EventItem?
	
}

protocol EventsListViewControllerDelegate : AnyObject {
	
}

class EventsListViewController: UITableViewController,
			UIPopoverPresentationControllerDelegate,
			CreateEventViewControllerDelegate,
			ChangeEventViewControllerDelegate {
	
	// MARK: - Properties
	
	weak var dataSource : EventsListViewControllerDataSource! {
		willSet {
			NotificationCenter.default.removeObserver(self,
						name: kEventDataDidChangeNotificationName, object: dataSource)
		}
		didSet {
			NotificationCenter.default.addObserver(self, selector:
						#selector(eventDataDidChange), name:
						kEventDataDidChangeNotificationName, object: dataSource)
		}
	}
	
	// MARK: - Internal methods

	deinit {
		print(String.init(format: "deinit of EventsListViewController %p", self))

		
		NotificationCenter.default.removeObserver(self,
					name: kEventDataDidChangeNotificationName, object: dataSource)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let navigationItem = parent?.navigationItem {
			let addButton = UIBarButtonItem(barButtonSystemItem: .add,
						target: self, action: #selector(insertNewObject(_:)))
			navigationItem.rightBarButtonItem = addButton
			navigationItem.title = NSLocalizedString("All Events", comment: "")
		}

		reloadData()
	}
	
	func insertNewObject(_ sender: Any) {
		performSegue(withIdentifier: kAddNewEventSegueIdentifier, sender: self)
	}
	
	func eventDataDidChange(_ notification: Notification) {
		reloadData()
	}

	// MARK: - Private methods

	private func reloadData() {
		self.dataSource?.reloadData(completion: { (status) in
			switch status {
			case .accessRestricted:
				self.showAlertAboutDeniedAccessToEvents()
			default:
				break
			}
			
			self.tableView.reloadData()
		})
	}
	
	private func showAlertAboutDeniedAccessToEvents() {
		let controller = UIAlertController.init(
					title: NSLocalizedString("Restricted access", comment: ""),
					message: NSLocalizedString("Change your privacy to allow the app to access of the calendar events", comment: ""),
					preferredStyle: .alert)
		
		var alertAction = UIAlertAction.init(
					title: NSLocalizedString("Settings", comment: ""),
					style: .default)
		{ (action) in
			UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!,
						options: [:], completionHandler: nil)
		}
		controller.addAction(alertAction)
		
		alertAction = UIAlertAction.init(
					title: NSLocalizedString("Cancel", comment: ""),
					style: .cancel, handler: nil)
		controller.addAction(alertAction)

		present(controller, animated: true, completion: nil)
	}
	
	private func setup(_ viewCell: UITableViewCell, for eventItem: EventItem) {
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

	// MARK: - CreateEventViewControllerDelegate methods
	
	func dissmissCreateEventViewController() {
		navigationController?.dismiss(animated: true, completion: nil)
	}

	func addNewEvent(title: String, subtitle: String) {
		navigationController?.dismiss(animated: true, completion: nil)
		
		
		
	}

	// MARK: - ChangeEventViewControllerDelegate methods
	
	
	
	// MARK: - UIPopoverPresentationControllerDelegate methods
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kAddNewEventSegueIdentifier {
			let popoverNavigationController = segue.destination as? UINavigationController
			let viewController = popoverNavigationController?.topViewController
						as? CreateEventViewController
			viewController?.delegate = self
			if let popover = popoverNavigationController?.popoverPresentationController {
				popover.delegate = self
				popover.barButtonItem = parent?.navigationItem.rightBarButtonItem
			}
		}
		if segue.identifier == kChangeEventSegueIdentifier {
			let viewController = segue.destination as? ChangeEventViewController
			viewController?.delegate = self
			if let indexPath = tableView.indexPathForSelectedRow {
				viewController?.eventItem = dataSource.eventItemAt(indexPath)
			}
		}
	}
	
}
