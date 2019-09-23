//
//  SignInViewReactor.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import RxCocoa
import Pure
import ReactorKit

class SignInViewReactor: Reactor, FactoryModule {

  struct Dependency {
    let authService: AuthServiceProtocol
    let alertService: AlertServiceProtocol
  }
  
  enum Action {
    case setId(String)
    case setPassword(String)
    case signIn
    case toggleShouldKeepAuth(Bool)
  }
  
  enum Mutation {
    case isSignedIn
    case setId(String)
    case setPassword(String)
    case setLoading(Bool)
    case toggleShouldKeepAuth(Bool)
  }
  
  struct State {
    var isLoading: Bool = false
    var id: String = ""
    var password: String = ""
    var isSignedIn: Bool = false
    var shouldKeepAuth: Bool = true
    var canSignIn: Bool = false
  }
  
  let initialState: State = State()
  
  private let dependency: Dependency
  
  required init(dependency: Dependency, payload: Void) {
    defer { _ = self.state }
    self.dependency = dependency
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setId(id):
      guard !self.currentState.isLoading else { return .empty() }
      return .just(.setId(id))
      
    case let .setPassword(password):
      guard !self.currentState.isLoading else { return .empty() }
      return .just(.setPassword(password))
      
    case let .toggleShouldKeepAuth(shouldKeepAuth):
      guard !self.currentState.isLoading else { return .empty() }
      return .just(.toggleShouldKeepAuth(shouldKeepAuth))
      
    case .signIn:
      guard !self.currentState.isLoading else { return .empty() }
      guard self.currentState.canSignIn else { return .empty() }
      return Observable.concat([
        Observable.just(.setLoading(true)),
        self.signInMutation(),
        Observable.just(.setLoading(false))
      ])
    }
  }
  
  private func signInMutation() -> Observable<Mutation> {
    let auth = Auth(id: self.currentState.id, password: self.currentState.password)
    return self.dependency.authService.authorize(auth: auth)
      .asObservable()
      .map { _ in .isSignedIn }
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
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setId(id):
      newState.id = id
      
    case let .setPassword(password):
      newState.password = password
    
    case let .toggleShouldKeepAuth(shouldKeepAuth):
      newState.shouldKeepAuth = shouldKeepAuth
      
    case .isSignedIn:
      newState.isSignedIn = true
    }
    
    newState.canSignIn = !newState.id.isEmpty && !newState.password.isEmpty
    
    return newState
  }
}
