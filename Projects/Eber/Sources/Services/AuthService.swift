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
  func authorize(auth: Auth) -> Single<Void>
}

final class AuthService: AuthServiceProtocol {
  
  private(set) var currentAccessToken: AccessToken?
  
  private let keychain = Keychain(service: "com.eber.keychain.ios")
  
  private let networking: Networking
  
  init(networking: Networking) {
    self.networking = networking
    self.currentAccessToken = self.loadAccessToken()
    log.debug("currentAccessToken exists: \(self.currentAccessToken != nil)")
  }
  
  func authorize(auth: Auth) -> Single<Void> {
    return self.networking.request(.target(AuthAPI.authorize(auth)))
      .map(AccessToken.self)
      .do(onSuccess: { [weak self] accessToken in
        self?.currentAccessToken = accessToken
        try? self?.saveAccessToken(accessToken)
      })
      .map { _ in }
  }
  
  private func saveAccessToken(_ accessToken: AccessToken) throws {
    try self.keychain.set(accessToken.accessToken, key: Keychain.Keys.accessToken)
  }
  
  private func loadAccessToken() -> AccessToken? {
    guard let accessToken = self.keychain[Keychain.Keys.accessToken] else { return nil }
    return AccessToken(accessToken: accessToken)
  }
  
  private func deleteAccessToken() {
    try? self.keychain.remove(Keychain.Keys.accessToken)
  }
}

extension Keychain {
  struct Keys {
    static let accessToken = "access_token"
  }
}
