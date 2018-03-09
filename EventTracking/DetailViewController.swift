//
//  DetailViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Private constants
private let kEventsListSegueIdentifier = "EventsList"

class DetailViewController: UIViewController {

	var eventDataProvider : EventDataProvider?
	
//	func configureView() {
//		// Update the user interface for the detail item.
//		if let detail = detailItem {
//		    if let label = detailDescriptionLabel {
//		        label.text = detail.timestamp!.description
//		    }
//		}
//	}
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		// Do any additional setup after loading the view, typically from a nib.
//		configureView()
//	}
//
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//		// Dispose of any resources that can be recreated.
//	}
//
//	var detailItem: Event? {
//		didSet {
//		    // Update the view.
//		    configureView()
//		}
//	}
	
	// MARK: - Segues
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kEventsListSegueIdentifier {
			let controller = segue.destination as! EventsListViewController
			controller.dataSource = eventDataProvider
			addChildViewController(controller)
		}
	}
	
}

