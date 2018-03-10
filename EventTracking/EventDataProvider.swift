//
//  EventDataProvider.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/8/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation
import EventKit

// Global constants

let kEventDataDidChangeNotificationName = Notification.Name(rawValue:
			"kEventDataDidChangeNotificationName")

class EventDataProvider: NSObject, EventsListViewControllerDataSource,
			EventsListViewControllerDelegate {
	
	// MARK: - Properties
	private var eventStore : EKEventStore {
		willSet {
			NotificationCenter.default.removeObserver(self,
						name: .EKEventStoreChanged, object: eventStore)
		}
		didSet {
			NotificationCenter.default.addObserver(self, selector:
						#selector(eventStoreChanged), name: .EKEventStoreChanged,
						object: eventStore)
		}
	}
	private var events = [EventItem]()
	private var fetchEventsQueue : DispatchQueue

	// MARK: - Internal methods
	
	override init() {
		eventStore = EKEventStore()
		fetchEventsQueue = DispatchQueue.init(label: "fetchEventsQueue")
		super.init()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self,
					name: .EKEventStoreChanged, object: eventStore)
	}
	
	func eventStoreChanged(_ notification: Notification) {
		NotificationCenter.default.post(name: kEventDataDidChangeNotificationName,
					object: self)
	}
	
	// MARK: - Private methods

	private func calendars() -> [EKCalendar] {
		let allEventCalendars = eventStore.calendars(for: .event)
		var filteredCalendars = [EKCalendar]()
		for calendar in allEventCalendars {
			if calendar.allowsContentModifications {
				filteredCalendars.append(calendar)
			}
		}
		return filteredCalendars
	}
	
	private func updateDataStructure(matching events: [EKEvent]) {
		for event in events {
			let item = EventItem(title: event.title, subtitle: event.notes ?? "")
			item.identifier = event.eventIdentifier
			self.events.append(item)
		}
	}
	
	private func authorizeToEventAccess(completion: @escaping (EKAuthorizationStatus) -> ()) {
		let status = EKEventStore.authorizationStatus(for: .event)
		switch status {
		case .notDetermined:
			eventStore.requestAccess(to: .event) { (flag, error) in
				if error != nil && flag {
					completion(.authorized)
				} else {
					completion(.denied)
				}
			}
		default:
			completion(status)
		}
	}
	
	private func fetchEventsFromCalendar(completion: @escaping () -> ()) {
		fetchEventsQueue.async {
			let currentDate = Date()
			
			
			
			let predicate = self.eventStore.predicateForEvents(withStart:
						currentDate.startOfDay, end: currentDate.endOfDay,
						calendars: self.calendars())
			let events = self.eventStore.events(matching: predicate)
			self.updateDataStructure(matching: events)
			
			completion()
		}
	}
	
	// MARK: - EventsListViewControllerDataSource methods
	
	func reloadData(completion: @escaping (ReloadDataStatus) -> ()) {
		events = []
		authorizeToEventAccess { (status) in
			switch status {
			case .denied, .restricted:
				DispatchQueue.main.async {
					completion(.accessRestricted)
				}
			case .authorized:
				self.fetchEventsFromCalendar {
					DispatchQueue.main.async {
						completion(.success)
					}
				}
			default:
				DispatchQueue.main.async {
					completion(.undefined)
				}
			}
		}
	}

	func numberOfEvents() -> Int {
		return events.count
	}
	
	func eventItemAt(_ indexPath: IndexPath) -> EventItem? {
		return events[indexPath.row]
	}
	
	// MARK: - EventsListViewControllerDelegate methods
	
	
	
}
