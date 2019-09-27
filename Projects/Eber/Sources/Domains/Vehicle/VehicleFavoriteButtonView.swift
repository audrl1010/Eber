//
//  VehicleFavoriteButtonView.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class VehicleFavoriteButtonView: UIView, View {
  
  typealias Reactor = VehicleFavoriteButtonViewReactor
  
  let button = UIButton().then {
    $0.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  var disposeBag = DisposeBag()
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 17.f, height: 17.f)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    self.setNeedsLayout()
    self.layoutIfNeeded()
    return CGSize(width: 17.f, height: 17.f)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.button)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.button.frame = self.bounds
  }
  
  func bind(reactor: Reactor) {
    reactor.state.map { _ in }
    .bind(to: self.rx.setNeedsLayout)
    .disposed(by: self.disposeBag)
    
    self.button.rx.tap
      .map { Reactor.Action.toggleFavorite }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
      
    reactor.state.map { !$0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.button.rx.isEnabled)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isFavorite }
      .distinctUntilChanged()
      .map { $0 ? R.image.favorite() : R.image.unfavorite() }
      .bind(to: self.button.rx.backgroundImage(for: .normal))
      .disposed(by: self.disposeBag)
  }
}
