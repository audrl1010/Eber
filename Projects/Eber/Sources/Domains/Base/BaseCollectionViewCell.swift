//
//  BaseCollectionViewCell.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import UIKit
import RxSwift

class BaseCollectionReusableView: UICollectionReusableView {
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }
}

class BaseCollectionViewCell: UICollectionViewCell {
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.disposeBag = DisposeBag()
  }
  
  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
