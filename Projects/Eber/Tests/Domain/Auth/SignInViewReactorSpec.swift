//
//  SignInViewReactorSpec.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//


import Nimble
import Quick
import Stubber
@testable import Eber

final class SignInViewReactorSpec: QuickSpec {
  
  override func spec() {
    
    func createReactor(authService: AuthServiceStub = .init()) -> SignInViewReactor {
      let factory = SignInViewReactor.Factory.init(dependency: .init(authService: authService))
      return factory.create()
    }
    
    func sendActionSetIdPassword(to reactor: SignInViewReactor) {
      reactor.action.onNext(.setId(AuthFixture.auth.id))
      reactor.action.onNext(.setPassword(AuthFixture.auth.password))
    }
    
    describe("an initial state") {
      var reactor: SignInViewReactor!
      
      beforeEach {
        reactor = createReactor()
      }
      
      it("is not loading") {

        expect(reactor.currentState.isLoading) == false
      }
      it("has empty id") {
        expect(reactor.currentState.id).to(beEmpty())
      }
      it("has empty password") {
        expect(reactor.currentState.password).to(beEmpty())
      }
      it("is not signed in") {
        expect(reactor.currentState.isSignedIn) == false
      }
      it("should keep auth") {
        expect(reactor.currentState.shouldKeepAuth) == true
      }
      it("can`t sign in") {
        expect(reactor.currentState.canSignIn) == false
      }
    }
    
    context("when receives an action.login") {
      it("tries to login") {
        let authService = AuthServiceStub()
        let reactor = createReactor(authService: authService)
        
        Stubber.register(authService.authorize) { auth in
          return .just(())
        }
        
        sendActionSetIdPassword(to: reactor)
        reactor.action.onNext(.signIn)
        
        expect(Stubber.executions(authService.authorize).count) == 1
      }
    }
    
    describe("state.id") {
      context("when receives an action.setId") {
        it("set") {
          let reactor = createReactor()
          reactor.action.onNext(.setId(AuthFixture.auth.id))
          expect(reactor.currentState.id) == AuthFixture.auth.id
        }
      }
    }

    describe("state.password") {
      context("when receives an action.setPassword") {
        it("set") {
          let reactor = createReactor()
          reactor.action.onNext(.setPassword(AuthFixture.auth.password))
          expect(reactor.currentState.password) == AuthFixture.auth.password
        }
      }
    }
    
    describe("state.shouldKeepAuth") {
      context("when receives an action.toggleShouldKeepAuth") {
        it("is toggled") {
          let reactor = createReactor()
          reactor.action.onNext(.toggleShouldKeepAuth)
          expect(reactor.currentState.shouldKeepAuth) == false
        }
      }
    }
    
    describe("state.isLoading") {
      var authService: AuthServiceStub!
      var reactor: SignInViewReactor!
      
      beforeEach {
        authService = AuthServiceStub()
        reactor = createReactor(authService: authService)
      }
      
      context("while authorizing") {
        it("is loading") {
          Stubber.register(authService.authorize) { auth in .never() }
          sendActionSetIdPassword(to: reactor)
          reactor.action.onNext(.signIn)
          expect(reactor.currentState.isLoading) == true
        }
      }
      
      context("when finished authorizing") {
        it("is not loading") {
          
          Stubber.register(authService.authorize) { auth in .just(()) }
          
          sendActionSetIdPassword(to: reactor)
          reactor.action.onNext(.signIn)
          expect(reactor.currentState.isLoading) == false
        }
      }
    }
    
    describe("state.canSignIn") {
      var reactor: SignInViewReactor!
      
      beforeEach {
        reactor = createReactor()
      }
      
      context("when there is password and id") {
        it("can sign in") {
          sendActionSetIdPassword(to: reactor)
          expect(reactor.currentState.canSignIn) == true
        }
      }
      
      context("when there is id and no password") {
        it("can not sign in") {
          reactor.action.onNext(.setPassword(AuthFixture.auth.id))
          expect(reactor.currentState.canSignIn) == false
        }
      }
      
      context("when there is password and no id") {
        it("can not sign in") {
          reactor.action.onNext(.setPassword(AuthFixture.auth.password))
          expect(reactor.currentState.canSignIn) == false
        }
      }
    }
    
    describe("state.isSignedIn") {
      var authService: AuthServiceStub!
      var reactor: SignInViewReactor!
      
      beforeEach {
         authService = AuthServiceStub()
         reactor = createReactor(authService: authService)
      }
      
      context("when succeeds to authorize") {
        it("is signed in") {
          Stubber.register(authService.authorize) { auth in .just(()) }
          sendActionSetIdPassword(to: reactor)
          reactor.action.onNext(.signIn)
          expect(reactor.currentState.isSignedIn) == true
        }
      }
      
      context("when fails to authorize") {
        it("is not signed in") {
          Stubber.register(authService.authorize) { auth in .error(TestError())}
          sendActionSetIdPassword(to: reactor)
          reactor.action.onNext(.signIn)
          expect(reactor.currentState.isSignedIn) == false
        }
      }
    }
  }
}
