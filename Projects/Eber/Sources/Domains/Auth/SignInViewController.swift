//
//  SignInViewController.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import AloeStackView

final class SignInViewController: BaseViewController {
  
  enum Metric {
    static let logoViewTop = 99.f
    static let logoViewSize = 120.f
    
    static let formItemLeftRight = 32.f
    
    static let idFormTextFieldTop = 21.f
    
    static let passwordFormTextFieldTop = 16.f
    
    static let keepingLoginFormCheckBoxTop = 17.f
    
    static let signInButtonTop = 58.f
    static let signInButtonHeight = 48.f
    
    static let findPasswordButtonTop = 8.f
    static let findPasswordButtonHeight = 48.f
  }
  
  let aloeStackView = AloeStackView().then {
    $0.hidesSeparatorsByDefault = true
    $0.alwaysBounceVertical = true
  }
  let logoView = UIImageView(image: R.image.eberLogo()).then {
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 4.f
    $0.clipsToBounds = true
  }
  let idFormTextField = FormTextField(title: "ID")
  let passwordFormTextField = FormTextField(title: "Password")
  let keepingLoginFormCheckBox = FormCheckBox(title: "로그인 상태 유지")
  let signInButton = UIButton().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4.f
    $0.titleLabel?.font = 16.f.appleSDGothicNeoFont.semibold
    $0.setTitleColor(.white_87, for: .normal)
    $0.setTitle("로그인", for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.shamrock).image, for: .normal)
    $0.adjustsImageWhenHighlighted = false
  }
  let findPasswordButton = UIButton().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4.f
    $0.layer.borderWidth = 1.f
    $0.layer.borderColor = UIColor.black_18.cgColor
    $0.titleLabel?.font = 16.f.appleSDGothicNeoFont.semibold
    $0.setTitleColor(.shamrock, for: .normal)
    $0.setTitle("비밀번호 찾기", for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.white).image, for: .normal)
    $0.adjustsImageWhenHighlighted = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.aloeStackView)
    
    self.aloeStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    let logoViewContainer = UIView()
    logoViewContainer.addSubview(self.logoView)
    
    self.aloeStackView.addRow(
      logoViewContainer,
      inset: UIEdgeInsets(top: Metric.logoViewTop, left: 0, bottom: 0, right: 0)
    )
    logoViewContainer.snp.makeConstraints { make in
      make.height.equalTo(Metric.logoViewSize)
    }
    self.logoView.snp.makeConstraints { make in
      make.width.height.equalTo(Metric.logoViewSize)
      make.centerX.equalToSuperview()
    }
    self.aloeStackView.addRow(
      self.idFormTextField,
      inset: UIEdgeInsets(
        top: Metric.idFormTextFieldTop,
        left: Metric.formItemLeftRight,
        bottom: 0,
        right: Metric.formItemLeftRight
      )
    )
    self.aloeStackView.addRow(
      self.passwordFormTextField,
      inset: UIEdgeInsets(
        top: Metric.passwordFormTextFieldTop,
        left: Metric.formItemLeftRight,
        bottom: 0,
        right: Metric.formItemLeftRight
      )
    )
    self.aloeStackView.addRow(
      self.keepingLoginFormCheckBox,
      inset: UIEdgeInsets(
        top: Metric.keepingLoginFormCheckBoxTop,
        left: Metric.formItemLeftRight,
        bottom: 0,
        right: Metric.formItemLeftRight
      )
    )
    self.aloeStackView.addRow(
      self.signInButton,
      inset: UIEdgeInsets(
        top: Metric.signInButtonTop,
        left: Metric.formItemLeftRight,
        bottom: 0,
        right: Metric.formItemLeftRight
      )
    )
    self.signInButton.snp.makeConstraints { make in
      make.height.equalTo(Metric.signInButtonHeight)
    }
    self.aloeStackView.addRow(
      self.findPasswordButton,
      inset: UIEdgeInsets(
        top: Metric.findPasswordButtonTop,
        left: Metric.formItemLeftRight,
        bottom: 0,
        right: Metric.formItemLeftRight
      )
    )
    self.findPasswordButton.snp.makeConstraints { make in
      make.height.equalTo(Metric.findPasswordButtonHeight)
    }
  }
}
