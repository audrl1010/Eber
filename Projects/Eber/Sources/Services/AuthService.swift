//
//  AuthService.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import KeychainAccess

protocol AuthServiceProtocol {
  var currentAccessToken: AccessToken? { get }
  func authorize(auth: Auth, shouldPreserveAccessToken: Bool) -> Single<AccessToken>
  func signOut()
}

final class AuthService: AuthServiceProtocol {
  
  private(set) var currentAccessToken: AccessToken?
  
  private let accessTokenStore: AccessTokenStoreProtocol
  
  private let networking: NetworkingProtocol
  
  init(networking: NetworkingProtocol, accessTokenStore: AccessTokenStoreProtocol) {
    self.networking = networking
    self.accessTokenStore = accessTokenStore
    self.currentAccessToken = self.accessTokenStore.loadAccessToken()
    log.debug("currentAccessToken exists: \(self.currentAccessToken != nil)")
  }
  
  func authorize(auth: Auth, shouldPreserveAccessToken: Bool) -> Single<AccessToken> {
    return self.networking.request(.target(AuthAPI.authorize(auth)))
      .map(AccessToken.self, atKeyPath: "data")
      .do(onSuccess: { [weak self] accessToken in
        self?.currentAccessToken = accessToken
        if shouldPreserveAccessToken {
          self?.accessTokenStore.saveAccessToken(accessToken)
        }
      })
  }
  
  func signOut() {
    self.currentAccessToken = nil
    self.accessTokenStore.deleteAccessToken()
  }
}
