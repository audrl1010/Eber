//
//  UICollectionView+TestUtils.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import UIKit

extension UICollectionView {
  func cell<Cell>(_ cellClass: Cell.Type, at section: Int, _ item: Int) -> Cell? {
    let indexPath = IndexPath(item: item, section: section)
    return self.dataSource?.collectionView(self, cellForItemAt: indexPath) as? Cell
  }
}
