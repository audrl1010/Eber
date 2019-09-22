//
//  CheckBox.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: CheckBox {
  
  var isOn: ControlProperty<Bool> {
    return value
  }
  
  var value: ControlProperty<Bool> {
    return self.controlProperty(
      editingEvents: [.allEditingEvents, .valueChanged],
      getter: { checkBox in checkBox.isOn },
      setter: { checkBox, isOn in checkBox.isOn = isOn }
    )
  }
}

class CheckBox: UIButton {
  
  enum Metric {
    static let size = 18.f
  }
  
  let iconView = UIImageView()
  
  var isOn: Bool {
    didSet {
      self.toggleIsOnImage()
      self.setNeedsLayout()
    }
  }
  
  var disposeBag = DisposeBag()
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: Metric.size, height: Metric.size)
  }
  
  init(isOn: Bool = false) {
    self.isOn = isOn
    super.init(frame: .zero)
    self.addSubview(self.iconView)
    self.toggleIsOnImage()
    self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
  }
  
  @objc private func didTouchUpInside() {
    self.isOn = !self.isOn
  }
  
  private func toggleIsOnImage() {
    self.iconView.image = self.isOn ? R.image.checkedCheckbox() : R.image.uncheckedCheckbox()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.iconView.width = self.bounds.width
    self.iconView.height = self.bounds.height
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
