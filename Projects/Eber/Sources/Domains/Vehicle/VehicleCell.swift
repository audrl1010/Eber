//
//  VehicleCell.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import UIKit
import ReactorKit

final class VehicleCell: BaseCollectionViewCell, View {
  
  typealias CellReactor = VehicleCellReactor
  
  enum Metric {
    static let licenseNumberLabelTop = 9.f
    static let favoriteButtonTop = 8.f
    static let favoriteButtonSize = 17.f
    static let capacityLabelTop = 10.f
    static let capacityLabelLeft = 8.f
  }
  
  enum Font {
    static let descriptionLabel = 12.f.appleSDGothicNeoFont.regular
    static let licenseNumberLabel = 20.f.appleSDGothicNeoFont.medium
    static let capacityLabel = 14.f.appleSDGothicNeoFont.regular
  }
  
  // MARK: UI
  
  let descriptionLabel = UILabel().then {
    $0.font = Font.descriptionLabel
    $0.textColor = .black_60
  }
  let licenseNumberLabel = UILabel().then {
    $0.font = Font.licenseNumberLabel
    $0.textColor = .black_87
  }
  let favoriteButton = UIButton().then {
    $0.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  let capacityLabel = UILabel().then {
    $0.font = Font.capacityLabel
    $0.textColor = .black_60
  }
  
  private let tapGestureRecognizer = UITapGestureRecognizer()
  
  // MARK: Initializing
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.addSubview(self.descriptionLabel)
    self.contentView.addSubview(self.favoriteButton)
    self.contentView.addSubview(self.licenseNumberLabel)
    self.contentView.addSubview(self.capacityLabel)
    self.contentView.addGestureRecognizer(self.tapGestureRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configuring
  
  func bind(reactor: CellReactor) {
    reactor.state.map { _ in }
    .bind(to: self.rx.setNeedsLayout)
    .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.description }
      .distinctUntilChanged()
      .bind(to: self.descriptionLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.licenseNumber }
      .distinctUntilChanged()
      .bind(to: self.licenseNumberLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { "\($0.capacity)" }
      .distinctUntilChanged()
      .map { "적재용량: \($0)t"}
      .bind(to: self.capacityLabel.rx.text)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isFavorite }
      .distinctUntilChanged()
      .map { $0 ? R.image.favorite() : R.image.unfavorite() }
      .bind(to: self.favoriteButton.rx.image(for: .normal))
      .disposed(by: self.disposeBag)
  }
  
  // MARK: Size
  
  class func size(width: CGFloat, reactor: CellReactor) -> CGSize {
    return CGSize(width: width, height: 76.f)
  }
  
  // MARK: Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.descriptionLabel.sizeToFit()
    self.descriptionLabel.width = self.bounds.width
    
    self.licenseNumberLabel.sizeToFit()
    self.licenseNumberLabel.top = self.descriptionLabel.bottom + Metric.licenseNumberLabelTop
    self.licenseNumberLabel.width = self.bounds.width
    
    self.favoriteButton.top = self.licenseNumberLabel.bottom + Metric.favoriteButtonTop
    self.favoriteButton.width = Metric.favoriteButtonSize
    self.favoriteButton.height = Metric.favoriteButtonSize
    
    self.capacityLabel.sizeToFit()
    self.capacityLabel.top = self.licenseNumberLabel.bottom + Metric.capacityLabelTop
    self.capacityLabel.left = self.favoriteButton.right + Metric.capacityLabelLeft
    self.capacityLabel.width = self.bounds.width - self.capacityLabel.left
  }
  
}
