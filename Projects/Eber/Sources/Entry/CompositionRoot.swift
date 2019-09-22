//
//  CompositionRoot.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation
import SnapKit

struct AppDependency {
  let window: UIWindow
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let netwokring = Networking(plugins: [])
    let accessTokenStore = AccessTokenStore()
    let authService = AuthService(networking: netwokring, accessTokenStore: accessTokenStore)
    let signInViewReactorFactory = SignInViewReactor.Factory(
      dependency: SignInViewReactor.Dependency(authService: authService)
    )
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = SignInViewController(
      dependency: (),
      payload: SignInViewController.Payload(
        reactor: signInViewReactorFactory.create()
      )
    )
    window.makeKeyAndVisible()
    return AppDependency(window: window)
  }
}

