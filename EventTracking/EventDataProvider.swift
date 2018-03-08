//
//  EventDataProvider.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/8/18.
//  Copyright © 2018 AL. All rights reserved.
//

import Foundation

class EventDataProvider: NSObject, EventsListViewControllerDataSource {
	
	// MARK: - MonthCollectionViewControllerDataSource methods
	
	func numberOfEvents() -> Int {
		return 0
	}
	
	func eventItemAt(_ indexPath: IndexPath) -> EventItem? {
		return EventItem()
	}
	
}
