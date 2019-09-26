//
//  SignedInCoordinator.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import Pure
import UIKit
import RxSwift
import RxCocoa

final class SignedInCoordinator: ViewCoordinator<NoRoute>, FactoryModule {
  
  struct Dependency {
    let vehicleListViewControllerFactory: VehicleListViewController.Factory
    let vehicleListViewReactorFactory: VehicleListViewReactor.Factory
  }
  
  struct Payload {
    var accessToken: AccessToken
  }
  
  private var vehicleListViewController: VehicleListViewController!
  
  private let dependency: Dependency
  
  let accessToken: AccessToken
  
  required init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.accessToken = payload.accessToken
    let vehicleListViewReactor = self.dependency.vehicleListViewReactorFactory.create()
    self.vehicleListViewController = self.dependency.vehicleListViewControllerFactory.create(
      payload: .init(reactor: vehicleListViewReactor)
    )
    super.init(rootViewController: self.vehicleListViewController)
  }
  
  override func start() {
    
  }
}
