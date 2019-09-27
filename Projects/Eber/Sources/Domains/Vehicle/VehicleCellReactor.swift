//
//  VehicleCellReactor.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import RxSwift
import ReactorKit
import Pure

class VehicleCellReactor: Reactor, FactoryModule {
  
  enum Action {
    case toggle
  }
  
  struct Dependency {
    let favoriteButtonViewReactorFactory: VehicleFavoriteButtonViewReactor.Factory
  }
  
  struct Payload {
    let vehicle: Vehicle
  }
  
  struct State {
    var description: String
    var favorite: Bool
    var licenseNumber: String
    var capacity: String
    
    fileprivate var vehicle: Vehicle
  }
  
  let initialState: State
  
  var vehicle: Vehicle {
    return self.currentState.vehicle
  }
  
  private let dependency: Dependency
  
  let favoriteButtonViewReactor: VehicleFavoriteButtonViewReactor
  
  required init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.favoriteButtonViewReactor = self.dependency.favoriteButtonViewReactorFactory.create(
      payload: .init(vehicle: payload.vehicle)
    )
    self.initialState = State(
      description: payload.vehicle.description,
      favorite: payload.vehicle.favorite,
      licenseNumber: payload.vehicle.licenseNumber,
      capacity: payload.vehicle.capacity.toDecimal(),
      vehicle: payload.vehicle
    )
  }
}

extension Factory where Module == VehicleCellReactor {
  func create(vehicle: Vehicle) -> Module {
    return self.create(payload: .init(vehicle: vehicle))
  }
}
