//
//  SplashViewControllerSpec.swift
//  Eber
//
//  Created by myung gi son on 24/09/2019.
//

import RxSwift
import Stubber
import Nimble
import Quick

@testable import Eber

final class SplashViewControllerSpec: QuickSpec {
  override func spec() {
    func createReactor(authService: AuthServiceStub = .init()) -> SplashViewReactor {
      let factory = SplashViewReactor.Factory.init(
        dependency: .init(authService: authService)
      )
      return factory.create()
    }
    
    var reactor: SplashViewReactor!
    var viewController: SplashViewController!
    
    beforeEach {
      reactor = createReactor()
      reactor.isStubEnabled = true
      let splashViewControllerFactory = SplashViewController.Factory(dependency: Void())
      viewController = splashViewControllerFactory.create(payload: .init(reactor: reactor))
      _ = viewController.view
    }
    
    describe("a view") {
      context("when did appear") {
        it("sends a '.checkIfAuthenticated' action to the reactor") {
          reactor.isStubEnabled = true
          viewController.viewDidAppear(false)
          expect(reactor.stub.actions.last).to(match) {
            if case .checkIfAuthenticated = $0 {
              return true
            } else {
              return false
            }
          }
        }
      }
    }
  }
}
