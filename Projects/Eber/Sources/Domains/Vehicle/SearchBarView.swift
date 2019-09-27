//
//  SearchBarView.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: SearchBarView {
  var text: ControlProperty<String?> {
    return self.base.textField.rx.text
  }
}

class SearchBarView: UIView {
  
  enum Metric {
    static let searchIconSize = 17.f
    static let searchIconLeft = 15.f
    static let textFieldHeight = 22.f
    static let textFieldLeft = 16.f
    static let textFieldRight = 15.f
  }
  let foregroundLayer = CALayer()
  let backgroundLayer = CALayer()
  
  let searchIcon = UIImageView(image: R.image.search())
  let textField = UITextField().then {
    $0.font = 16.f.appleSDGothicNeoFont.regular
    $0.attributedPlaceholder = "차량 정보를 검색하세요"
      .withFont(16.f.appleSDGothicNeoFont.regular)
      .withTextColor(.black_38)
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 48.f)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.foregroundLayer.masksToBounds = true
    self.foregroundLayer.backgroundColor = UIColor.white.cgColor
    
    self.backgroundLayer.masksToBounds = false
    self.backgroundLayer.shadowColor = UIColor.black.cgColor
    self.backgroundLayer.shadowOffset = CGSize(width: 0, height: 1)
    self.backgroundLayer.shadowOpacity = 0.5
    self.backgroundLayer.shadowRadius = 0.5
    
    self.layer.addSublayer(self.backgroundLayer)
    self.layer.addSublayer(self.foregroundLayer)
    self.addSubview(self.searchIcon)
    self.addSubview(self.textField)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.backgroundLayer.frame = self.bounds
    self.foregroundLayer.frame = self.bounds
    
    self.backgroundLayer.shadowPath = UIBezierPath(
      roundedRect: self.bounds,
      cornerRadius: self.foregroundLayer.cornerRadius
    ).cgPath
    
    self.searchIcon.width = Metric.searchIconSize
    self.searchIcon.height = Metric.searchIconSize
    self.searchIcon.left = Metric.searchIconLeft
    self.searchIcon.centerY = self.bounds.centerY
    
    self.textField.left = self.searchIcon.right + Metric.textFieldLeft
    self.textField.width = self.bounds.width - self.textField.left + Metric.textFieldRight
    self.textField.height = Metric.textFieldHeight
    self.textField.centerY = self.bounds.centerY
  }
}
