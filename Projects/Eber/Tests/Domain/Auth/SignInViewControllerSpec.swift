//
//  SignInViewControllerSpec.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import Stubber
import Nimble
import Quick

@testable import Eber

final class SignInViewControllerSpec: QuickSpec {
  override func spec() {
    func createReactor(authService: AuthServiceStub = .init()) -> SignInViewReactor {
      let factory = SignInViewReactor.Factory.init(dependency: .init(authService: authService))
      return factory.create()
    }
    
    var reactor: SignInViewReactor!
    var viewController: SignInViewController!
    
    beforeEach {
      reactor = createReactor()
      reactor.isStubEnabled = true
      let signInViewControllerFactory = SignInViewController.Factory(dependency: Void())
      viewController = signInViewControllerFactory.create(payload: .init(reactor: reactor))
      _ = viewController.view
    }
    
    describe("a idFormTextField") {
      context("when inputting") {
        it("sends a setId action") {
          viewController.idFormTextField.textField.text = AuthFixture.auth.id
          viewController.idFormTextField.textField.sendActions(for: .editingChanged)
          expect(reactor.stub.actions.last).to(match) {
            if case .setId(let id) = $0 {
              return id == AuthFixture.auth.id
            } else {
              return false
            }
          }
        }
      }
    }
    
    describe("a passwordFormTextField") {
      context("when inputting") {
        it("sends a setPassword action") {
          viewController.passwordFormTextField.textField.text = AuthFixture.auth.password
          viewController.passwordFormTextField.textField.sendActions(for: .editingChanged)
          expect(reactor.stub.actions.last).to(match) {
            if case .setPassword(let password) = $0 {
              return password == AuthFixture.auth.password
            } else {
              return false
            }
          }
        }
      }
    }
    
    describe("a keepingLoginFormCheckBox") {
      context("when triggers") {
        it("sends a toggleShouldKeepAuth action") {
          viewController.keepingLoginFormCheckBox.checkBox.isOn = true
          viewController.keepingLoginFormCheckBox.checkBox.sendActions(for: .valueChanged)
          expect(reactor.stub.actions.last).to(match) {
            if case .toggleShouldKeepAuth(let shouldKeepAuth) = $0 {
              return shouldKeepAuth == true
            } else {
              return false
            }
          }
        }
      }
    }
    
    describe("a signInButton") {
      context("when can signIn") {
        it("is enabled") {
          reactor.stub.state.value.canSignIn = true
          expect(viewController.signInButton.isEnabled) == true
        }
      }
      context("when not can signIn") {
        it("is not enabled") {
          reactor.stub.state.value.canSignIn = false
          expect(viewController.signInButton.isEnabled) == false
        }
      }
      context("when triggers") {
        it("sends a toggleShouldKeepAuth action") {
          viewController.signInButton.sendActions(for: .touchUpInside)
          expect(reactor.stub.actions.last).to(match) {
            if case .signIn = $0 {
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
