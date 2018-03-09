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
private let kEventViewCellIdentifier = "EventViewCell"

enum AuthorizationStatus : Int {
	
	case notDetermined
	case restricted
	case denied
	case authorized
	case undefined
}

// Protocols declaretion
protocol EventsListViewControllerDataSource : AnyObject {
	
	func authorizationStatus() -> AuthorizationStatus
	func requestEventAccess(completion: @escaping (Bool, Error?) -> ())
	
	func reloadData(completion: @escaping (Bool, Error?) -> ())
	
	func numberOfEvents() -> Int
	func eventItemAt(_ indexPath: IndexPath) -> EventItem?
	
}

protocol EventsListViewControllerDelegate : AnyObject {
	
}

class EventsListViewController: UITableViewController,
			UIPopoverPresentationControllerDelegate,
			CreateEventViewControllerDelegate {
	
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
		NotificationCenter.default.removeObserver(self,
					name: kEventDataDidChangeNotificationName, object: dataSource)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let parent = self.parent {
			let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
			parent.navigationItem.rightBarButtonItem = addButton
			parent.title = NSLocalizedString("All Events", comment: "")
		}
		
		performAuthorization()
	}
	
	func insertNewObject(_ sender: Any) {
		performSegue(withIdentifier: kAddNewEventSegueIdentifier, sender: self)
	}
	
	func eventDataDidChange(_ notification: Notification) {
		reloadData()
	}

	// MARK: - Private methods

	private func performAuthorization() {
		let status = dataSource?.authorizationStatus() ?? .undefined
		switch status {
		case .notDetermined:
			dataSource.requestEventAccess { (flag, error) in
				if error == nil && flag {
					self.reloadData()
				}
			}
		case .denied, .restricted:
			showAlertAboutDeniedAccessToEvents()
		case .authorized:
			reloadData()
		default:
			break
		}
	}
	
	private func reloadData() {
		self.dataSource.reloadData(completion: { (flag, error) in
			if error == nil && flag {
				self.tableView.reloadData()
			}
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

	// MARK: - UIPopoverPresentationControllerDelegate methods
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
	
	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kAddNewEventSegueIdentifier {
			let navigationController = segue.destination as? UINavigationController
			let viewController = navigationController?.topViewController
						as? CreateEventViewController
			viewController?.delegate = self
			if let popover = navigationController?.popoverPresentationController {
				popover.delegate = self
				popover.barButtonItem = parent?.navigationItem.rightBarButtonItem
			}
		}
	}
	
}
