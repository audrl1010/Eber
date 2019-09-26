//
//  VehicleListViewReactor.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import ReactorKit
import Pure

final class VehicleListViewReactor: Reactor, FactoryModule {
  
  typealias Section = VehicleListViewSection
  typealias SectionItem = VehicleListViewSection.Item
  
  struct Dependency {
    let vehicleService: VehicleServiceProtocol
    let alertService: AlertServiceProtocol
    let cellReactorFactory: VehicleCellReactor.Factory
  }
  
  enum Action {
    case refresh
    case updateQuery(String)
  }
  
  enum Mutation {
    case setVehicles([Vehicle])
    case setLoading(Bool)
    case setQuery(String)
  }
  
  struct State {
    var isRefreshing: Bool = false
    var isLoading: Bool = false
    var query: String = ""
    var sections: [Section] = []
  }
  
  let initialState: State = State()
  
  private let dependency: Dependency
  
  init(dependency: Dependency, payload: Void) {
    self.dependency = dependency
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      guard !self.currentState.isLoading else { return .empty() }
      return Observable.concat([
        .just(.setLoading(true)),
        self.refreshMutation(),
        .just(.setLoading(false))
      ])
      
    case let .updateQuery(query):
      guard !self.currentState.isLoading else { return .empty() }
      return .just(.setQuery(query))
    }
  }
  
  private func refreshMutation() -> Observable<Mutation> {
    return self.dependency.vehicleService.vehicles()
      .asObservable()
      .debug()
      .map { vehicles in .setVehicles(vehicles) }
      .catchError(self.errorMutation)
  }
  
  private func errorMutation(error: Error) -> Observable<Mutation> {
    guard let clientError = error as? EberClientError else { return .empty() }
    return self.dependency.alertService
      .show(alert: NetworkingAlert(clientError: clientError))
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setVehicles(vehicles):
      let sectionItems: [SectionItem] = vehicles
        .map(self.dependency.cellReactorFactory.create)
        .map(SectionItem.init)
      let sections = [
        VehicleListViewSection(items: sectionItems)
      ]
      newState.sections = sections
      
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setQuery(query):
      newState.query = query
    }
    return newState
  }
}
