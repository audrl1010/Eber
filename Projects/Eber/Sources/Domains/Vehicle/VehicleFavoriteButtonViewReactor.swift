//
//  VehicleFavoriteButtonViewReactor.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import RxSwift
import ReactorKit
import Pure

class VehicleFavoriteButtonViewReactor: Reactor, FactoryModule {
  
  struct Dependency {
    let vehicleService: VehicleServiceProtocol
    let alertService: AlertServiceProtocol
  }
  
  struct Payload {
    let vehicle: Vehicle
  }
  
  enum Action {
    case toggleFavorite
  }
  
  enum Mutation {
    case setLoading(Bool)
    case setFavorite(Bool)
  }
  
  struct State {
    fileprivate let vehicleIdx: Int
    var isLoading: Bool
    var isFavorite: Bool
  }
  
  let initialState: State
  private let dependency: Dependency
  
  var vehicleIdx: Int {
    return self.currentState.vehicleIdx
  }
  
  required init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State(
      vehicleIdx: payload.vehicle.vehicleIdx,
      isLoading: false,
      isFavorite: payload.vehicle.favorite
    )
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let fromVehicleEvent = Vehicle.event.flatMap { [weak self] event in
      self?.mutation(from: event) ?? .empty()
    }
    return Observable.of(mutation, fromVehicleEvent).merge()
  }
  
  private func mutation(from event: Vehicle.Event) -> Observable<Mutation> {
    switch event {
    case let .updateFavorite(id, isFavorite):
      guard id == self.vehicleIdx else { return .empty() }
      return Observable.just(.setFavorite(isFavorite))
    }
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleFavorite:
      return Observable.concat([
        .just(.setLoading(true)),
        self.currentState.isFavorite ? self.unfavoriteMutation() : self.favoriteMutation(),
        .just(.setLoading(false))
      ])
    }
  }
  
  private func favoriteMutation() -> Observable<Mutation> {
    return self.dependency.vehicleService.favorite(vehicleIdx: self.vehicleIdx)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in .empty() }
      .catchError { _ -> Observable<Mutation> in .empty() }
  }
  
  private func unfavoriteMutation() -> Observable<Mutation> {
    return self.dependency.vehicleService.unfavorite(vehicleIdx: self.vehicleIdx)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in .empty() }
      .catchError { _ -> Observable<Mutation> in .empty() }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setFavorite(isFavorite):
      newState.isFavorite = isFavorite
      
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    }
    return newState
  }
}
