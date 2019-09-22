//
//  FormCheckBox.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: FormCheckBox {
  var isOn: ControlProperty<Bool> {
    return self.base.checkBox.rx.isOn
  }
}

class FormCheckBox: UIView {
  
  enum Font {
    static let titleLabel = 13.6.f.notoSansCJKKR.regular
  }
  enum Metric {
    static let spacing = 11.f
  }
  
  let titleLabel = UILabel().then {
    $0.textColor = .black_60
    $0.font = Font.titleLabel
  }
  let checkBox = CheckBox(isOn: false)
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = Metric.spacing
  }
  
  var disposeBag = DisposeBag()
  
  init(title: String) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.checkBox.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    self.stackView.addArrangedSubview(self.checkBox)
    self.stackView.addArrangedSubview(self.titleLabel)
    
    self.addSubview(self.stackView)
    
    self.stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
