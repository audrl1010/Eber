//
//  SignedOutCoordinator.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import Pure
import UIKit
import RxSwift
import RxCocoa

final class SignedOutCoordinator: ViewCoordinator<NoRoute>, FactoryModule {
  
  struct Dependency {
    let signInViewControllerFactory: SignInViewController.Factory
    let signInViewReactorFactory: SignInViewReactor.Factory
  }
  
  private let dependency: Dependency
  
  private var signInViewController: SignInViewController!
  
  var result: Observable<AccessToken> {
    return self.resultRelay.asObservable()
  }
  
  private let resultRelay = PublishRelay<AccessToken>()
  
  required init(dependency: Dependency, payload: Void) {
    self.dependency = dependency
    let signInViewReactor = self.dependency.signInViewReactorFactory.create(payload: ())
    let signInViewController = self.dependency.signInViewControllerFactory.create(
      payload: .init(reactor: signInViewReactor)
    )
    self.signInViewController = signInViewController
    super.init(rootViewController: signInViewController)
  }
  
  override func start() {
    self.signInViewController.rx.signInStatus
      .map { signInStatus -> AccessToken? in
        if case let .signedIn(accessToken) = signInStatus {
          return accessToken
        } else {
          return nil
        }
      }
      .filterNil()
      .bind(to: self.resultRelay)
      .disposed(by: self.disposeBag)
  }
}
