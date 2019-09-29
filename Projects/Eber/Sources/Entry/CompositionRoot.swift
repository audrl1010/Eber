//
//  CompositionRoot.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation
import SnapKit
import Moya

struct AppDependency {
  let window: UIWindow
  let appCoordinator: AppCoordinator
}

extension AppDependency {
  
  static func resolve() -> AppDependency {
    let accessTokenStore = AccessTokenStore()
    let authPlugin = AuthPlugin()
    let plugins: [PluginType] = [authPlugin]
    let netwokring = Networking(plugins: plugins)
    let authService = AuthService(networking: netwokring, accessTokenStore: accessTokenStore)
    authPlugin.authService = authService
    
    let alertService = AlertService()
    let vehicleService = VehicleService(networking: netwokring)
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()
    
    let splashViewControllerFactory = SplashViewController.Factory()
    let splashViewReactorFactory = SplashViewReactor.Factory(
      dependency: .init(authService: authService)
    )
    let vehicleListViewControllerFactory = VehicleListViewController.Factory()
    let vehicleCellReactorFactory = VehicleCellReactor.Factory()
    let vehicleListViewReactorFactory = VehicleListViewReactor.Factory(
      dependency: VehicleListViewReactor.Dependency(
        vehicleService: vehicleService,
        alertService: alertService,
        cellReactorFactory: vehicleCellReactorFactory
      )
    )
    
    let signedInCoordinatorFactory = SignedInCoordinator.Factory(
      dependency: .init(
        vehicleListViewControllerFactory: vehicleListViewControllerFactory,
        vehicleListViewReactorFactory: vehicleListViewReactorFactory
      )
    )
    
    let signInViewControllerFactory = SignInViewController.Factory()
    let signInViewReactorFactory = SignInViewReactor.Factory(
      dependency: .init(
        authService: authService,
        alertService: alertService
      )
    )
    
    let signedOutCoordinatorFactory = SignedOutCoordinator.Factory(
      dependency: SignedOutCoordinator.Dependency(
        signInViewControllerFactory: signInViewControllerFactory,
        signInViewReactorFactory: signInViewReactorFactory
      )
    )
    
    let authenticatingCoordinatorFactory = AuthenticatingCoordinator.Factory(
      dependency: AuthenticatingCoordinator.Dependency(
        splashViewControllerFactory: splashViewControllerFactory,
        splashViewReactorFactory: splashViewReactorFactory
      )
    )
    
    let appCoordinator = AppCoordinator(
      dependency: .init(
        window: window,
        authenticatingCoordinatorFactory: authenticatingCoordinatorFactory,
        signedInCoordinatorFactory: signedInCoordinatorFactory,
        signedOutCoordinatorFactory: signedOutCoordinatorFactory
      ),
      payload: Void()
    )
    
    return AppDependency(
      window: window,
      appCoordinator: appCoordinator
    )
  }
}

