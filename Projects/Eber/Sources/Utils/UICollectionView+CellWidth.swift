//
//  UICollectionView+CellWidth.swift
//  Eber
//
//  Created by myung gi son on 21/09/2019.
//

import UIKit

extension UICollectionView {
  func sectionWidth(at section: Int) -> CGFloat {
    var width = self.width
    width -= self.contentInset.left
    width -= self.contentInset.right
    
    if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
      let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
      width -= inset.left
      width -= inset.right
    } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
      width -= layout.sectionInset.left
      width -= layout.sectionInset.right
    }
    
    return width
  }
}
