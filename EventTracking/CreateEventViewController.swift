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
	func addNewEvent(title: String, subtitle: String)
	
}

class CreateEventViewController : UIViewController, UITextViewDelegate {
	
	// MARK: - Properties
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var detailTextView: UITextView!

	weak var delegate : CreateEventViewControllerDelegate?
	private var detailTextViewPlaceholder = ""
	
	// MARK: - Internal methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		detailTextViewPlaceholder = detailTextView.text
		detailTextView.textColor = .lightGray
		detailTextView.layer.cornerRadius = 5
		detailTextView.layer.borderColor =
					UIColor.gray.withAlphaComponent(0.5).cgColor
		detailTextView.layer.borderWidth = 0.5
		detailTextView.clipsToBounds = true
		validateAddButton()
	}
	
	// MARK: - Private methods
	
	private func validateAddButton() {
		let title = titleTextField.text ?? ""
		navigationItem.rightBarButtonItem?.isEnabled = title != ""
	}

	// MARK: - Action methods
	
	@IBAction func cancelButtonPressed(_ sender: UIButton) {
		delegate?.dissmissCreateEventViewController()
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
		let title = titleTextField.text ?? ""
		var subtitle = detailTextView.text ?? ""
		if detailTextView.textColor == .lightGray {
			subtitle = ""
		}
		delegate?.addNewEvent(title: title, subtitle: subtitle)
	}
	
	@IBAction func titleDidChange(_ sender: Any) {
		validateAddButton()
	}

	// MARK: - UITextViewDelegate methods

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == detailTextViewPlaceholder {
			textView.text = ""
			textView.textColor = .black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text == "" {
			textView.text = detailTextViewPlaceholder
			textView.textColor = .lightGray
		}
	}
	
}

