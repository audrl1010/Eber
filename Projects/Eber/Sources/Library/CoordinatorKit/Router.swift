//
//  Router.swift
//  CoordinatorEx
//
//  Created by myung gi son on 19/04/2019.
//  Copyright © 2019 Myung Gi Son. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RouterType: class {
  associatedtype R = Route
  func navigate(to: R)
}

extension RouterType {
  func navigate(to route: R) {}
}

class RouterBase<RouteType: Route>: RouterType {
  typealias R = RouteType
  func navigate(to: R) {}
}

class Router<RouteType: Route>: RouterType {
  typealias R = RouteType
  typealias Base = RouterBase<RouteType>
  
  private weak var base: Base?
  
  init() {}
  
  init(base: Base) {
    self.base = base
  }
  
  fileprivate func setBase(base: Base) {
    self.base = base
  }
  
  func navigate(to route: RouteType) {
    self.base?.navigate(to: route)
  }
}

class LazyRouter<RouteType: Route>: Router<RouteType> {
  func set(base: Base) {
    self.setBase(base: base)
  }
}
