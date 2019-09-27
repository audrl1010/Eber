//
//  ToolbarView.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import UIKit

class ToolbarView: UIView {
  
  enum Metric {
    static let height = 56.f
    
    static let containerViewBottom = 44.f
    
    static let menuButtonViewLeft = 16.f
    static let menuButtonViewTop = 15.f
    static let menuButtonViewWidth = 26.f
    static let menuButtonViewHeight = 26.f
  }
  
  let menuButton = UIButton().then {
    $0.setBackgroundImage(R.image.menu(), for: .normal)
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .shamrock
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: Metric.height)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.containerView)
    self.addSubview(self.menuButton)
    
    self.containerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
      // enlarge background for iPhone X
      make.bottom.equalToSuperview().offset(Metric.containerViewBottom)
    }
    self.menuButton.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Metric.menuButtonViewLeft)
      make.top.equalToSuperview().offset(Metric.menuButtonViewTop)
      make.width.equalTo(Metric.menuButtonViewWidth)
      make.height.equalTo(Metric.menuButtonViewHeight)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
