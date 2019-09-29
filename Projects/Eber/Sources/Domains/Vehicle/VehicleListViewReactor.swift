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
  
  typealias SectionState = VehicleListViewSectionState
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
    case setSectionState(SectionState)
    case setLoading(Bool)
    case setQuery(String)
  }
  
  struct State {
    var isLoading: Bool = false
    var query: String = ""
    var sectionState: SectionState = NoQueryingSectionState()
    var sectionItems: [SectionItem] = []
    var sections: [Section] {
      return [sectionState.section(sectionItems: sectionItems)]
    }
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
        .just(.setQuery(query)),
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
    return Observable.just(
      !query.isEmpty
      ? Mutation.setSectionState(QueryingSectionState(query: query))
      : Mutation.setSectionState(NoQueryingSectionState())
    )
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
      
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setQuery(query):
      newState.query = query
      
    case let .setSectionState(sectionState):
      newState.sectionState = sectionState
    }
    return newState
  }
  
  private func sectionItems(from vehicles: [Vehicle]) -> [SectionItem] {
    return vehicles
    .map(self.dependency.cellReactorFactory.create)
    .map(SectionItem.init)
  }
  
  func transform(state: Observable<State>) -> Observable<State> {
    return state.flatMapLatest { state -> Observable<State> in
      let cellReactors = state.sectionItems.map { $0.cellReactor }
      let cellReactorStates = Observable.merge(cellReactors.map { $0.state.skip(1) })
      return Observable.merge(.just(state), cellReactorStates.withLatestFrom(Observable.just(state)))
    }
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

protocol VehicleListViewSectionState {
  func section(sectionItems: [VehicleListViewSection.Item]) -> VehicleListViewSection
}

extension VehicleListViewReactor {
  
  struct QueryingSectionState: VehicleListViewSectionState {
    var query: String
    
    func section(sectionItems: [VehicleListViewSection.Item]) -> VehicleListViewSection {
      let filteredSectionItems = sectionItems.filter { sectionItem in
        let `query` = self.query.lowercased().removeWhitespace()
        let licenseNumber = sectionItem.cellReactor.licenseNumber.lowercased().removeWhitespace()
        let description = sectionItem.cellReactor.description.lowercased().removeWhitespace()
        return licenseNumber.isMatch(of: query) || description.isMatch(of: query)
      }
      let favoriteSectionItems = filteredSectionItems
        .filter { $0.cellReactor.isFavorite }
        .sorted(by: <)
       
      let unfavoriteSectionItems = filteredSectionItems
        .filter { !$0.cellReactor.isFavorite }
        .sorted(by: <)
      return Section(items: favoriteSectionItems + unfavoriteSectionItems)
    }
  }
  
  struct NoQueryingSectionState: VehicleListViewSectionState {
    func section(sectionItems: [VehicleListViewSection.Item]) -> VehicleListViewSection {
      let favoriteSectionItems = sectionItems
        .filter { $0.cellReactor.isFavorite }
        .sorted(by: <)
       
      let unfavoriteSectionItems = sectionItems
        .filter { !$0.cellReactor.isFavorite }
        .sorted(by: <)
      return Section(items: favoriteSectionItems + unfavoriteSectionItems)
    }
  }
}
