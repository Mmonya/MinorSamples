//
//  BodyEventViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/10/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Protocols declaretion
protocol BodyEventViewControllerDelegate : AnyObject {
	
	func dissmissEventViewController()
	
}

class BodyEventViewController : UIViewController, UITextViewDelegate {
	
	// MARK: - Properties
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var detailTextView: UITextView!
	private var detailTextViewPlaceholder = ""

	var baseDelegate : BodyEventViewControllerDelegate? {
		return nil
	}

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
		validateDoneButton()
	}
	
	func validateDoneButton() {
		let title = titleTextField.text ?? ""
		navigationItem.rightBarButtonItem?.isEnabled = title != ""
	}
	
	// MARK: - Action methods
	
	@IBAction func cancelButtonPressed(_ sender: UIButton) {
		baseDelegate?.dissmissEventViewController()
	}
	
	@IBAction func doneButtonPressed(_ sender: UIButton) {
	}
	
	@IBAction func titleDidChange(_ sender: Any) {
		validateDoneButton()
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

