//
//  AuthenticatingCoordinator.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import Pure
import UIKit
import RxSwift
import RxCocoa

final class AuthenticatingCoordinator: ViewCoordinator<NoRoute>, FactoryModule {
  
  struct Dependency {
    let splashViewControllerFactory: SplashViewController.Factory
    let splashViewReactorFactory: SplashViewReactor.Factory
  }
  
  private let dependency: Dependency
  
  private var splashViewController: SplashViewController!
  
  var result: Observable<AuthenticationStatus> {
    return self.resultRelay.asObservable()
  }
  
  private let resultRelay = PublishRelay<AuthenticationStatus>()
  
  required init(dependency: Dependency, payload: Void) {
    self.dependency = dependency
    let splashViewReactor = self.dependency.splashViewReactorFactory.create(payload: ())
    let splashViewController = self.dependency.splashViewControllerFactory.create(
      payload: .init(reactor: splashViewReactor)
    )
    self.splashViewController = splashViewController
    super.init(rootViewController: splashViewController)
  }
  
  override func start() {
    self.splashViewController.rx.authenticationStatus
      .bind(to: self.resultRelay)
      .disposed(by: self.disposeBag)
  }
}
