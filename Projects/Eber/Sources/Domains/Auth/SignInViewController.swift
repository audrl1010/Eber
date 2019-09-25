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
import RxKeyboard
import AloeStackView
import Pure
import SwiftyColor
import JGProgressHUD

extension Reactive where Base: SignInViewController {
  var signInStatus: ControlEvent<SignInStatus> {
    guard let reactor = self.base.reactor else {
      fatalError("reactor is not connected to \(self)")
    }
    let source = reactor.state.map { $0.signInStatus }
      .distinctUntilChanged()
    return ControlEvent(events: source)
  }
}

final class SignInViewController: BaseViewController, View, FactoryModule {

  typealias Reactor = SignInViewReactor

  struct Payload {
    let reactor: Reactor
  }
  
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
  
  let progressHUD = JGProgressHUD(style: .extraLight)
  let aloeStackView = AloeStackView().then {
    $0.hidesSeparatorsByDefault = true
  }
  let logoView = UIImageView(image: R.image.eberLogo()).then {
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 4.f
    $0.clipsToBounds = true
  }
  let idFormTextField = FormTextField(title: "ID").then {
    $0.textField.autocapitalizationType = .none
  }
  let passwordFormTextField = FormTextField(title: "Password").then {
    $0.textField.isSecureTextEntry = true
  }
  let keepingLoginFormCheckBox = FormCheckBox(title: "로그인 상태 유지")
  let signInButton = UIButton().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4.f
    $0.titleLabel?.font = 16.f.appleSDGothicNeoFont.semibold
    $0.setTitleColor(.white_87, for: .normal)
    $0.setTitleColor(.white_42, for: .disabled)
    $0.setTitle("로그인", for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.shamrock).image, for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.shamrock).image, for: .disabled)
    $0.adjustsImageWhenHighlighted = false
  }
  let findPasswordButton = UIButton().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4.f
    $0.layer.borderWidth = 1.f
    $0.layer.borderColor = UIColor.black_18.cgColor
    $0.titleLabel?.font = 16.f.appleSDGothicNeoFont.semibold
    $0.setTitleColor(.shamrock, for: .normal)
    $0.setTitleColor(.shamrock_42, for: .disabled)
    $0.setTitle("비밀번호 찾기", for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.white).image, for: .normal)
    $0.adjustsImageWhenHighlighted = false
  }
  
  required init(dependency: Void, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    self.setUpToAdjustInsetWhenKeyboardUpOrDown()
  }
  
  private func setUpToAdjustInsetWhenKeyboardUpOrDown() {
    let tapGesture = UITapGestureRecognizer()
    self.view.addGestureRecognizer(tapGesture)
    tapGesture.rx.event.map { _ in }
      .subscribe(onNext: { [weak self] in
        self?.view.endEditing(true)
      })
      .disposed(by: self.disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let self = self else { return }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.aloeStackView.contentInset.bottom = keyboardVisibleHeight
          self.aloeStackView.scrollIndicatorInsets.bottom = self.aloeStackView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func bind(reactor: Reactor) {
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.progressHUD.rx.animate(in: self.view))
      .disposed(by: self.disposeBag)
    
    self.idFormTextField.rx.text
      .filterNil()
      .skip(1)
      .map(Reactor.Action.setId)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.id }
      .distinctUntilChanged()
      .bind(to: self.idFormTextField.rx.text)
      .disposed(by: self.disposeBag)
    
    self.passwordFormTextField.rx.text
      .filterNil()
      .skip(1)
      .map(Reactor.Action.setPassword)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.password }
      .distinctUntilChanged()
      .bind(to: self.passwordFormTextField.rx.text)
      .disposed(by: self.disposeBag)
    
    self.keepingLoginFormCheckBox.rx.isOn
      .skip(1)
      .map(Reactor.Action.toggleShouldKeepAuth)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.shouldKeepAuth }
      .distinctUntilChanged()
      .bind(to: self.keepingLoginFormCheckBox.rx.isOn)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.canSignIn }
      .bind(to: self.signInButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
    
    self.signInButton.rx.tap
      .map { Reactor.Action.signIn }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
}
