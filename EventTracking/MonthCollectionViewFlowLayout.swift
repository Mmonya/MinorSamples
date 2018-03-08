//
//  MonthCollectionViewFlowLayout.swift
//  EventTracking
//
//  Created by Dima Manyahin on 3/1/18.
//  Copyright © 2018 AL. All rights reserved.
//

import UIKit

class MonthCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	private var contentOffset = CGPoint()
	private var contentSize = CGSize()
	
	func applyPosition(to layoutAttributes: UICollectionViewLayoutAttributes) {
		var frame = CGRect(origin: CGPoint(), size: layoutAttributes.size)
		let indexPath = layoutAttributes.indexPath
		frame.origin.x = CGFloat(indexPath.row) * frame.size.width + contentOffset.x
		frame.origin.y = CGFloat(indexPath.section) * frame.size.height + contentOffset.y
		layoutAttributes.frame = frame
	}
	
	override func prepare() {
		super.prepare()
		
		var contentSize = CGSize()
		guard let collectionView = self.collectionView else {
			return
		}
		guard let itemSize = super.layoutAttributesForItem(at:
					IndexPath(row: 0, section: 0))?.size else {
			return
		}
		
		contentSize.height = itemSize.height * CGFloat(collectionView.numberOfSections)
		contentSize.width = itemSize.width * CGFloat(collectionView.numberOfItems(inSection: 0))

		self.contentSize = contentSize
		
		let collectionViewContentSize = self.collectionViewContentSize
		
		if contentSize.width <= collectionViewContentSize.width {
			contentOffset.x = (collectionViewContentSize.width - contentSize.width) / 2
		}
		
		if contentSize.height <= collectionViewContentSize.height {
			contentOffset.y = (collectionViewContentSize.height - contentSize.height) / 2
		}
	}
	
	override var collectionViewContentSize: CGSize {
		var collectionViewContentSize = collectionView?.frame.size ?? CGSize()
		let contentSize = self.contentSize
		
		collectionViewContentSize.height = max(contentSize.height,
					collectionViewContentSize.height)
		collectionViewContentSize.width = max(contentSize.width,
					collectionViewContentSize.width)
		
		return collectionViewContentSize
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var allAttributesInRect = [UICollectionViewLayoutAttributes]()
		guard let collectionView = self.collectionView else {
			return allAttributesInRect
		}
		for section in 0..<collectionView.numberOfSections {
			for row in 0..<collectionView.numberOfItems(inSection: section) {
				let indexPath = IndexPath(row: row, section: section)
				if let attributes = self.layoutAttributesForItem(at: indexPath) {
					if attributes.frame.intersects(rect) {
						allAttributesInRect.append(attributes)
					}
				}
			}
		}
		return allAttributesInRect
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
			return nil
		}
		applyPosition(to: attributes)
		return attributes
	}
	
}
