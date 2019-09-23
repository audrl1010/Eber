//
//  SplashViewReactorSpec.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import Nimble
import Quick
import Stubber

@testable import Eber

final class SplashViewReactorSpec: QuickSpec {
  
  override func spec() {
    func createReactor(authService: AuthServiceStub = .init()) -> SplashViewReactor {
      let factory = SplashViewReactor.Factory.init(
        dependency: .init(authService: authService)
      )
      return factory.create()
    }

    var authService: AuthServiceStub!
    var reactor: SplashViewReactor!
    
    beforeEach {
      authService = AuthServiceStub()
      reactor = createReactor(authService: authService)
    }
    
    describe("an initial state") {
      it("doesn`t have authenticationStatus") {
        expect(reactor.currentState.authenticationStatus).to(beNil())
      }
    }
    
    describe("state.authenticationStatus") {
      context("when receives an action.checkIfAuthenticated") {
        context("when authService doesn`t have access token") {
          it("set AuthenticationStatus.unAuthenticated") {
            authService.currentAccessToken = nil
            reactor.action.onNext(.checkIfAuthenticated)
            expect(reactor.currentState.authenticationStatus) == .unAuthenticated
          }
        }
        
        context("when authService has access token") {
          it("set AuthenticationStatus.authenticated") {
            authService.currentAccessToken = AccessTokenFixture.accessToken
            reactor.action.onNext(.checkIfAuthenticated)
            expect(reactor.currentState.authenticationStatus) == .authenticated(AccessTokenFixture.accessToken)
          }
        }
      }
    }
  }
}
