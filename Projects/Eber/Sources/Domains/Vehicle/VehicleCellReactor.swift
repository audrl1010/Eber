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
    var vehicleIdx: Int
    var description: String
    var licenseNumber: String
    var capacity: String
    var isFavorite: Bool
  }
  
  var vehicleIdx: Int {
    return self.currentState.vehicleIdx
  }
  var isFavorite: Bool {
    return self.currentState.isFavorite
  }
  var licenseNumber: String {
    return self.currentState.licenseNumber
  }
  var description: String {
    return self.currentState.description
  }
  
  let initialState: State
  
  private let dependency: Dependency
  
  let favoriteButtonViewReactor: VehicleFavoriteButtonViewReactor
  
  required init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.favoriteButtonViewReactor = self.dependency.favoriteButtonViewReactorFactory.create(
      payload: .init(vehicle: payload.vehicle)
    )
    self.initialState = State(
      vehicleIdx: payload.vehicle.vehicleIdx,
      description: payload.vehicle.description,
      licenseNumber: payload.vehicle.licenseNumber,
      capacity: payload.vehicle.capacity.toDecimal(),
      isFavorite: payload.vehicle.favorite
    )
  }
  
  func transform(state: Observable<State>) -> Observable<State> {
    let favoriteState = self.favoriteButtonViewReactor.state.skip(1)
      .distinctUntilChanged { $0.isFavorite }
    
    let newState = favoriteState.withLatestFrom(state) { favoriteState, state -> State in
      var newState = state
      newState.isFavorite = favoriteState.isFavorite
      return newState
    }
    return Observable.merge(state, newState)
  }
}

extension Factory where Module == VehicleCellReactor {
  func create(vehicle: Vehicle) -> Module {
    return self.create(payload: .init(vehicle: vehicle))
  }
}
