//
//  SplashViewReactor.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import RxSwift
import ReactorKit
import Pure

enum AuthenticationStatus {
  case authenticated(AccessToken)
  case unAuthenticated
}

extension AuthenticationStatus: Equatable {
  static func == (lhs: AuthenticationStatus, rhs: AuthenticationStatus) -> Bool {
    switch (lhs, rhs) {
    case let (.authenticated(a), .authenticated(b)):
      return a.accessToken == b.accessToken
      
    case (.unAuthenticated, .unAuthenticated):
      return true
      
    default:
      return false
    }
  }
}

class SplashViewReactor: Reactor, FactoryModule {
  
  struct Dependency {
    let authService: AuthServiceProtocol
  }
  
  enum Action {
    case checkIfAuthenticated
  }
  
  enum Mutation {
    case setAuthenticationStatus(AuthenticationStatus)
  }
  
  struct State {
    var authenticationStatus: AuthenticationStatus?
  }
  
  let initialState = State()
  
  private let dependency: Dependency
  
  required init(dependency: Dependency, payload: Void) {
    self.dependency = dependency
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkIfAuthenticated:
      return self.checkIfAuthenticatedMutation()
    }
  }
  
  private func checkIfAuthenticatedMutation() -> Observable<Mutation> {
    guard let accessToken = dependency.authService.currentAccessToken else {
      return .just(.setAuthenticationStatus(.unAuthenticated))
    }
    return .just(.setAuthenticationStatus(.authenticated(accessToken)))
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setAuthenticationStatus(authenticationStatus):
      newState.authenticationStatus = authenticationStatus
    }
    return newState
  }
}
