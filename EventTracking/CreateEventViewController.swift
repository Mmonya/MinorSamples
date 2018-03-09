//
//  CreateEventViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/9/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Protocols declaretion
protocol CreateEventViewControllerDelegate : AnyObject {
	
	func dissmissCreateEventViewController()
//	func rawValueChoosed(_ rawValue: String, forPresentedItemAt indexPath: IndexPath)
	
}

class CreateEventViewController : UIViewController {
	
	// MARK: - Properties

	weak var delegate : CreateEventViewControllerDelegate?

	// MARK: - Internal methods
	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		navigationController?.setNavigationBarHidden(false, animated: false)
//		
//		
//	}
//	
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		
//		print("")
//	}
	
	// MARK: - Action methods
	
	@IBAction func cancelButtonPressed(_ sender: UIButton) {
		delegate?.dissmissCreateEventViewController()
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {

	}

}

