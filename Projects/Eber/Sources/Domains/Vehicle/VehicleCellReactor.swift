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
  
  typealias Action = NoAction
  
  struct Dependency {}
  
  struct Payload {
    let vehicle: Vehicle
  }
  
  struct State {
    var description: String
    var favorite: Bool
    var licenseNumber: String
    var capacity: String
  }
  
  let initialState: State
  
  private let dependency: Dependency
  
  required init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State(
      description: payload.vehicle.description,
      favorite: payload.vehicle.favorite,
      licenseNumber: payload.vehicle.licenseNumber,
      capacity: payload.vehicle.capacity.toDecimal()
    )
  }
}

extension Factory where Module == VehicleCellReactor {
  func create(vehicle: Vehicle) -> Module {
    return self.create(payload: .init(vehicle: vehicle))
  }
}
