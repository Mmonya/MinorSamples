//
//  MasterViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController {

	var dataProvider = DataProvider.init(date: Date())

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
//		navigationItem.leftBarButtonItem = editButtonItem
//
//		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//		navigationItem.rightBarButtonItem = addButton
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.identifier == "showDetail" {
//		    if let indexPath = tableView.indexPathForSelectedRow {
//		    let object = fetchedResultsController.object(at: indexPath)
//		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//		        controller.detailItem = object
//		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//		        controller.navigationItem.leftItemsSupplementBackButton = true
//		    }
//		}
		
		
		if segue.identifier == "MonthPreview" {
			let controller = segue.destination as! MonthCollectionViewController
			controller.dataSource = dataProvider
			controller.delegate = dataProvider
			dataProvider.reloadData()
		}
		if segue.identifier == "MonthList" {
			let controller = segue.destination as! MonthsListViewController
			controller.delegate = dataProvider
			controller.dataSource = dataProvider
		}

	}



}

