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
	private var currentAuthorizationStatus = AuthorizationStatus.undefined
	private var eventStore : EKEventStore
	private var selectedCalendar : EKCalendar!
	private var events = [EKEvent]()
	private var fetchEventsQueue : DispatchQueue

	// MARK: - Internal methods
	
	override init() {
		eventStore = EKEventStore()
		fetchEventsQueue = DispatchQueue.init(label: "fetchEventsQueue")
		super.init()

		NotificationCenter.default.addObserver(self, selector:
					#selector(eventStoreChanged), name: .EKEventStoreChanged,
					object: eventStore)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self,
					name: .EKEventStoreChanged, object: eventStore)
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
	
	func eventStoreChanged(_ notification: Notification) {
		NotificationCenter.default.post(name: kEventDataDidChangeNotificationName,
					object: self)
	}
	
	// MARK: - EventsListViewControllerDataSource methods
	
	func authorizationStatus() -> AuthorizationStatus {
		currentAuthorizationStatus = AuthorizationStatus(rawValue:
					EKEventStore.authorizationStatus(for: .event).rawValue)
					?? .undefined
		return currentAuthorizationStatus
	}

	func requestEventAccess(completion: @escaping (Bool, Error?) -> ()) {
		eventStore.requestAccess(to: .event) { (flag, error) in
			if error != nil && flag {
				self.currentAuthorizationStatus = .authorized
			}
			completion(flag, error)
		}
	}
	
	func reloadData(completion: @escaping (Bool, Error?) -> ()) {
		if currentAuthorizationStatus == .authorized {
			selectedCalendar = eventStore.defaultCalendarForNewEvents
			events = []
			fetchEventsQueue.async {
				let currentDate = Date()
				
				let predicate = self.eventStore.predicateForEvents(withStart:
							currentDate.startOfDay, end: currentDate.endOfDay,
							calendars: [self.selectedCalendar])
				self.events = self.eventStore.events(matching: predicate)
				
				DispatchQueue.main.async {
					completion(true, nil)
				}
			}
		}
	}

	func numberOfEvents() -> Int {
		return events.count
	}
	
	func eventItemAt(_ indexPath: IndexPath) -> EventItem? {
		let event = events[indexPath.row]
		return EventItem(title: event.title, subtitle: event.notes ?? "")
	}
	
	// MARK: - EventsListViewControllerDelegate methods
	
	
	
}
