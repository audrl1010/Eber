//
//  UICollectionView+emptyView.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import UIKit

public extension UICollectionView {
  func emptyCell(for indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = "UICollectionView.emptyCell"
    self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    cell.isHidden = true
    return cell
  }
  
  func emptyView(for indexPath: IndexPath, kind: String) -> UICollectionReusableView {
    let identifier = "UICollectionView.emptyView"
    self.register(UICollectionReusableView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    view.isHidden = true
    return view
  }
}
