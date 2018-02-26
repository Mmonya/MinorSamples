//
//  MonthCollectionViewController.swift
//  EventTracking
//
//  Created by Dima Manyahin on 2/26/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

class MonthCollectionViewController : UICollectionViewController {
	
	//  Constants
	private let kWorkingDayCellKey = "WorkingDayViewCell"

	// MARK: - Collection View methods

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: kWorkingDayCellKey, for: indexPath)
	}
	
}
