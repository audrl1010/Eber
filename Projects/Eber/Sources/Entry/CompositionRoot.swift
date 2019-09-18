//
//  CompositionRoot.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct AppDependency {
  
}

extension AppDependency {
  static func resolve() -> AppDependency {
    return AppDependency()
  }
}
