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
    case updateFavorite(Bool)
  }
  
  enum Mutation {
    case updateFavorite(Bool)
  }
  
  struct Payload {
    let vehicle: Vehicle
  }
  
  struct State {
    var description: String
    var licenseNumber: String
    var capacity: String
    var isFavorite: Bool
    fileprivate var vehicle: Vehicle
  }
  
  var vehicle: Vehicle {
    return self.currentState.vehicle
  }
  
  let initialState: State
  
  private let dependency: Dependency
  
  required init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State(
      description: payload.vehicle.description,
      licenseNumber: payload.vehicle.licenseNumber,
      capacity: payload.vehicle.capacity.toDecimal(),
      isFavorite: payload.vehicle.favorite,
      vehicle: payload.vehicle
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateFavorite(isFavorite):
      return .just(.updateFavorite(isFavorite))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .updateFavorite(isFavorite):
      newState.isFavorite = isFavorite
      newState.vehicle.favorite = isFavorite
    }
    return newState
  }
}

extension Factory where Module == VehicleCellReactor {
  func create(vehicle: Vehicle) -> Module {
    return self.create(payload: .init(vehicle: vehicle))
  }
}
