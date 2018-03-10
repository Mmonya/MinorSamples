//
//  ChangeEventViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/10/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

// Protocols declaretion
protocol ChangeEventViewControllerDelegate : AnyObject {
	
	//	func addNewEvent(title: String, subtitle: String)
	
}

class ChangeEventViewController : UIViewController, UITextViewDelegate {
	
	// MARK: - Properties
	private var detailTextViewPlaceholder = ""
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var detailTextView: UITextView!
	
	weak var delegate : ChangeEventViewControllerDelegate?
	var eventItem : EventItem?
	
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
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let eventItem = self.eventItem {
			titleTextField.text = eventItem.title
			if !eventItem.subtitle.isEmpty {
				detailTextView.textColor = .black
			}
			detailTextView.text = eventItem.subtitle
		}
		validateDoneButton()
	}
	
	// MARK: - Private methods
	
	private func validateDoneButton() {
		let title = titleTextField.text ?? ""
		let isTitleChanged = titleTextField.text != eventItem?.title
		let isSubtitleChanged = detailTextView.text != eventItem?.subtitle
		navigationItem.rightBarButtonItem?.isEnabled = title != "" &&
					(isTitleChanged || isSubtitleChanged)
	}
	
	// MARK: - Action methods
	
	@IBAction func doneButtonPressed(_ sender: UIButton) {
		let title = titleTextField.text ?? ""
		var subtitle = detailTextView.text ?? ""
		if detailTextView.textColor == .lightGray {
			subtitle = ""
		}
//		delegate?.addNewEvent(title: title, subtitle: subtitle)
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

