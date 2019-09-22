//
//  FormTextField.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import UIKit
import RxSwift
import RxCocoa

class PaddingTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 18, dy: 12)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 18, dy: 12)
  }
}

extension Reactive where Base: FormTextField {
  var text: ControlProperty<String?> {
    return self.base.textField.rx.text
  }
}

class FormTextField: UIView {
  
  enum Font {
    static let titleLabel = 13.f.appleSDGothicNeoFont.regular
    static let textField = 15.f.appleSDGothicNeoFont.regular
  }
  enum Metric {
    static let spacing = 6.f
    static let textFieldHeight = 48.f
  }
  
  let titleLabel = UILabel().then {
    $0.font = Font.titleLabel
    $0.textColor = .black_60
  }
  let textField = PaddingTextField().then {
    $0.font = Font.textField
    $0.textColor = .black_60
    $0.tintColor = .shamrock
    $0.layer.borderColor = UIColor.black_18.cgColor
    $0.layer.cornerRadius = 4.f
    $0.layer.borderWidth = 1.f
  }
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    $0.spacing = Metric.spacing
  }
  
  override var intrinsicContentSize: CGSize {
    var height = 0.f
    height += Font.titleLabel.lineHeight
    height += Metric.spacing
    height += Metric.textFieldHeight
    return CGSize(width: UIView.noIntrinsicMetric, height: height)
  }
  
  init(title: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    
    self.stackView.addArrangedSubview(self.titleLabel)
    self.stackView.addArrangedSubview(self.textField)
    
    self.addSubview(self.stackView)
    
    self.textField.snp.makeConstraints { make in
      make.height.equalTo(Metric.textFieldHeight)
    }
    self.stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
