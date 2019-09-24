//
//  AuthServiceSpec.swift
//  Eber
//
//  Created by myung gi son on 21/09/2019.
//

import RxSwift
import KeychainAccess
import Quick
import Nimble
import Stubber
import Moya
import RxBlocking

@testable import Eber

final class AuthServiceSpec: QuickSpec {
  
  override func spec() {
    
    func createAuthService(
      networking: NetworkingStub = .init(),
      accessTokenStore: AccessTokenStoreStub = .init()
    ) -> AuthService {
      return AuthService(networking: networking, accessTokenStore: accessTokenStore)
    }
    
    var accessTokenStoreStub: AccessTokenStoreStub!
    var networkingStub: NetworkingStub!
    var authService: AuthService!
    
    beforeEach {
      accessTokenStoreStub = AccessTokenStoreStub()
      networkingStub = NetworkingStub()
      authService = createAuthService(
        networking: networkingStub,
        accessTokenStore: accessTokenStoreStub
      )
    }
    
    context("while initializing") {
      it("loads access token from AccessTokenStore") {
        Stubber.register(accessTokenStoreStub.loadAccessToken) { _ in nil }
        authService = createAuthService(accessTokenStore: accessTokenStoreStub)
        expect(Stubber.executions(accessTokenStoreStub.loadAccessToken).count) == 1
      }
    }
    
    context("when succeeds to authorize") {
      beforeEach {
        Stubber.register(accessTokenStoreStub.saveAccessToken) { _ in }
        Stubber.register(networkingStub.request) { _ in
          let json: [String: Any?] = [
            "data": [
              "token": AccessTokenFixture.accessToken.accessToken,
            ]
          ]
          let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
          return .just(Response(statusCode: 200, data: jsonData))
        }
      }
      context("when access token should be preserved") {
        it("saves access token to AccessTokenStore") {
          _ = authService.authorize(auth: AuthFixture.auth, shouldPreserveAccessToken: true).toBlocking().materialize()
          expect(authService.currentAccessToken?.accessToken) == AccessTokenFixture.accessToken.accessToken
          expect(Stubber.executions(accessTokenStoreStub.saveAccessToken).count) == 1
        }
      }
      context("when access token should not be preserved") {
        it("doesn`t save access token to AccessTokenStore") {
          _ = authService.authorize(auth: AuthFixture.auth, shouldPreserveAccessToken: false).toBlocking().materialize()
          expect(authService.currentAccessToken?.accessToken) == AccessTokenFixture.accessToken.accessToken
          expect(Stubber.executions(accessTokenStoreStub.saveAccessToken).count) == 0
        }
      }
    }

    context("when sign out") {
      it("remove access token from AccessTokenStore") {
        Stubber.register(accessTokenStoreStub.deleteAccessToken) { _ in }
        authService.signOut()
        expect(authService.currentAccessToken).to(beNil())
        expect(Stubber.executions(accessTokenStoreStub.deleteAccessToken).count) == 1
      }
    }
  }
}
