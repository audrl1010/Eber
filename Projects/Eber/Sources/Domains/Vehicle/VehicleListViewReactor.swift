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
    case setFilteredSectionItems([SectionItem])
    case setLoading(Bool)
    case setQuery(String)
  }
  
  struct State {
    var isLoading: Bool = false
    var query: String = ""
    var sectionItems: [SectionItem] = []
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
      guard self.currentState.query != query else { return .empty() }
      guard !self.currentState.isLoading else { return .empty() }
      return Observable.concat([
        .just(Mutation.setQuery(query)),
        self.searchVehicles(query: query)
          // cancel previous '.updateQuery' action.
          .takeUntil(self.action.filter(Action.isUpdateQueryAction))
      ])
    }
  }
  
  private func refreshMutation() -> Observable<Mutation> {
    return self.dependency.vehicleService.vehicles()
      .asObservable()
      .debug()
      .map { vehicles in .setVehicles(vehicles) }
      .catchError(self.errorMutation)
  }
  
  private func searchVehicles(query: String) -> Observable<Mutation> {
    let isFiltering = !query.isEmpty
    if isFiltering {
      let vehicles = self.currentState.sectionItems.map { sectionItem in
        sectionItem.cellReactor.vehicle
      }
      let filteredVehicles = vehicles.search(
        query: query,
        partialMatchTargets: [\.licenseNumber, \.description]
      )
      return .just(.setFilteredSectionItems(self.sectionItems(from: filteredVehicles)))
    } else {
      return .just(.setFilteredSectionItems(self.currentState.sectionItems))
    }
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
      let sectionItems = self.sectionItems(from: vehicles)
      newState.sectionItems = sectionItems
      newState.sections = [VehicleListViewSection(items: sectionItems)]
      
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setQuery(query):
      newState.query = query
      
    case let .setFilteredSectionItems(filteredSectionItems):
      newState.sections = [VehicleListViewSection(items: filteredSectionItems)]
    }
    return newState
  }
  
  private func sectionItems(from vehicles: [Vehicle]) -> [SectionItem] {
    return vehicles
    .map(self.dependency.cellReactorFactory.create)
    .map(SectionItem.init)
  }
}

extension VehicleListViewReactor.Action {
  static func isUpdateQueryAction(_ action: VehicleListViewReactor.Action) -> Bool {
    if case .updateQuery = action {
      return true
    } else {
      return false
    }
  }
}
