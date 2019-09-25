//
//  AppCoordinator.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import Pure
import UIKit
import RxSwift
import RxCocoa

enum AppRoute: Route {
  case signedIn(AccessToken)
  case signedOut
}

final class AppCoordinator: ViewCoordinator<AppRoute> {
  
  struct Dependency {
    let window: UIWindow
    let authenticatingCoordinatorFactory: AuthenticatingCoordinator.Factory
    let signedInCoordinatorFactory: SignedInCoordinator.Factory
    let signedOutCoordinatorFactory: SignedOutCoordinator.Factory
  }
  
  private let dependency: Dependency
  
  private var authenticatingCoordinator: AuthenticatingCoordinator!
  private var signedInCoordinator: SignedInCoordinator!
  private var signedOutCoordinator: SignedOutCoordinator!
  
  required init(dependency: Dependency, payload: Void) {
    self.dependency = dependency
    self.authenticatingCoordinator = self.dependency.authenticatingCoordinatorFactory.create()
    self.dependency.window.rootViewController = self.authenticatingCoordinator.rootViewController
    super.init(rootViewController: self.authenticatingCoordinator.rootViewController)
  }
  
  override func start() {
    self.authenticatingCoordinator.result
      .map { status in
        switch status {
        case let .authenticated(accessToken):
          return .signedIn(accessToken)
          
        case .unAuthenticated:
          return .signedOut
        }
      }
      .bind(to: self.route)
      .disposed(by: self.disposeBag)
    self.coordinate(subCoordinator: self.authenticatingCoordinator)
  }
  
  override func navigate(to route: AppRoute) {
    switch route {
    case let .signedIn(accessToken):
      self.coordinateSignedIn(accessToken)
      
    case .signedOut:
      self.coordinateSignedOut()
    }
  }
  
  private func coordinateSignedIn(_ accessToken: AccessToken) {
    self.signedInCoordinator = self.dependency.signedInCoordinatorFactory.create(
      payload: .init(accessToken: accessToken)
    )
    self.dependency.window.rootViewController = self.signedInCoordinator.rootViewController
    self.coordinate(subCoordinator: signedInCoordinator)
  }
  
  private func coordinateSignedOut() {
    self.signedOutCoordinator = self.dependency.signedOutCoordinatorFactory.create()
    self.dependency.window.rootViewController = self.signedOutCoordinator.rootViewController
    self.signedOutCoordinator.result
      .map(AppRoute.signedIn)
      .bind(to: self.route)
      .disposed(by: self.disposeBag)
    self.coordinate(subCoordinator: self.signedOutCoordinator)
  }
}
