//
//  ThreeColumnLayout.swift
//  UserFlow
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit

/// A collection view layout with a fixed number of columns set at 3
/// Don't set the itemSize, it's calculated automatically based on
/// Collection view width
class ThreeColumnLayout: UICollectionViewFlowLayout {

    private var columnsCount: Int = 3

    override var itemSize: CGSize {
        get {
            return calculateItemSize()
        }
        set {
            // See the classe's documentation
        }
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else {
            return context
        }
        let hasChangedBounds = newBounds != collectionView?.bounds
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = hasChangedBounds
        return context
    }

    private func calculateItemSize() -> CGSize {
        guard let currentWidth = collectionView?.bounds.width else {
            return .zero
        }

        let columnsCount = CGFloat(self.columnsCount)
        let edgesSpacing = sectionInset.left + sectionInset.right
        let interitemSpacing = minimumInteritemSpacing * (columnsCount - 1)
        let itemsTotalWidth = currentWidth - (edgesSpacing + interitemSpacing)
        let itemWidth = (itemsTotalWidth / columnsCount).rounded(.down)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }
}
