//
//  Coordinator.swift
//  CoordinatorEx
//
//  Created by myung gi son on 18/04/2019.
//  Copyright © 2019 Myung Gi Son. All rights reserved.
//
import RxSwift
import RxCocoa
import UIKit

typealias WindowCoordinator<RouteType: Route> = Coordinator<RouteType, UIWindow>

typealias NavigationCoordinator<RouteType: Route> = Coordinator<RouteType, UINavigationController>

typealias TabbarCoordinator<RouteType: Route> = Coordinator<RouteType, UITabBarController>

class ViewCoordinator<RouteType: Route>: Coordinator<RouteType, UIViewController> {
  func setChild(_ viewController: UIViewController) {
    self.rootViewController.addChild(viewController)
    self.rootViewController.view.addSubview(viewController.view)
    viewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    viewController.didMove(toParent: self.rootViewController)
  }
}

protocol CoordinatorType: class {
  var parent: CoordinatorType? { get set }
  var identifier: String { get set }
  func start()
  func finish()
  func store(subCoordinator: CoordinatorType)
  func free(subCoordinator: CoordinatorType)
  func freeAll()
}

extension Coordinator {
  func asRouter() -> Router<RouteType> {
    return Router(base: self)
  }
}

extension Coordinator {
  var route: Binder<RouteType> {
    return Binder(self) { coordinator, route in
      coordinator.navigate(to: route)
    }
  }
  
  var free: Binder<CoordinatorType> {
    return Binder(self) { coordinator, subCoordinator in
      coordinator.free(subCoordinator: subCoordinator)
    }
  }
}

class Coordinator<RouteType: Route, RootViewControllerType: Presentable>: RouterBase<RouteType>, CoordinatorType {
  typealias R = RouteType
  typealias RootViewController = RootViewControllerType
  
  var disposeBag = DisposeBag()
  
  weak var parent: CoordinatorType?
  
  var identifier: String = UUID().uuidString
  
  private(set) var childCoordinators: [String: CoordinatorType] = [:]
  
  private let lock = NSRecursiveLock()
  
  init(rootViewController: RootViewController) {
    self.rootViewController = rootViewController
  }
  
  let rootViewController: RootViewController
  
  func start() { /* implement */ }
  
  func finish() {
    self.freeAll()
    self.parent?.free(subCoordinator: self)
  }
  
  func coordinate(subCoordinator: CoordinatorType) {
    self.store(subCoordinator: subCoordinator)
    subCoordinator.start()
  }
  
  func store(subCoordinator: CoordinatorType) {
    self.lock.lock()
    subCoordinator.parent = self
    self.childCoordinators[subCoordinator.identifier] = subCoordinator
    self.lock.unlock()
  }
  
  func free(subCoordinator: CoordinatorType) {
    self.lock.lock()
    self.childCoordinators[subCoordinator.identifier] = nil
    self.lock.unlock()
  }
  
  func freeAll() {
    self.lock.lock()
    self.childCoordinators.removeAll()
    self.lock.unlock()
  }
}

class BaseCoordinator<ResultType, RouteType: Route> {
  let disposeBag = DisposeBag()
  
  private let identifier = UUID()
  private var childCoordinators: [UUID: Any] = [:]
  
  private func store<T, R: Route>(coordinator: BaseCoordinator<T, R>) {
    self.childCoordinators[coordinator.identifier] = coordinator
  }
  
  private func free<T, R: Route>(coordinator: BaseCoordinator<T, R>) {
    self.childCoordinators[coordinator.identifier] = nil
  }
  
  func coordinate<T, R: Route>(to coordinator: BaseCoordinator<T, R>) -> Observable<T> {
    self.store(coordinator: coordinator)
    return coordinator.start()
      .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
  }
  
  func start() -> Observable<ResultType> {
    fatalError("Start method should be implemented.")
  }
  
  func navigate(to route: RouteType) {}
}

