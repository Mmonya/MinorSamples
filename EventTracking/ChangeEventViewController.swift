//
//  ChangeEventViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/10/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Protocols declaretion
protocol ChangeEventViewControllerDelegate : BodyEventViewControllerDelegate {
	
//	func addNewEvent(title: String, subtitle: String)
	
}

class ChangeEventViewController : BodyEventViewController {
	
	// MARK: - Properties
	override var baseDelegate : BodyEventViewControllerDelegate? {
		return self.delegate
	}
	
	weak var delegate : ChangeEventViewControllerDelegate?
	
	// MARK: - Internal methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	// MARK: - Action methods
	
	@IBAction override func doneButtonPressed(_ sender: UIButton) {
		super.doneButtonPressed(sender)
		let title = titleTextField.text ?? ""
		var subtitle = detailTextView.text ?? ""
		if detailTextView.textColor == .lightGray {
			subtitle = ""
		}
//		delegate?.addNewEvent(title: title, subtitle: subtitle)
	}
	
}

