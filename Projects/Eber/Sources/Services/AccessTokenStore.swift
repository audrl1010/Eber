//
//  AccessTokenStore.swift
//  Eber
//
//  Created by myung gi son on 21/09/2019.
//

import Foundation
import KeychainAccess

extension Keychain {
  struct Keys {
    static let accessToken = "access_token"
  }
}

protocol AccessTokenStoreProtocol {
  func saveAccessToken(_ accessToken: AccessToken)
  func loadAccessToken() -> AccessToken?
  func deleteAccessToken()
}

final class AccessTokenStore: AccessTokenStoreProtocol {
  
  private let keychain = Keychain(service: "com.eber.keychain.ios")
  
  func saveAccessToken(_ accessToken: AccessToken) {
    try? self.keychain.set(accessToken.accessToken, key: Keychain.Keys.accessToken)
  }
  
  func loadAccessToken() -> AccessToken? {
    guard let accessToken = self.keychain[Keychain.Keys.accessToken] else { return nil }
    return AccessToken(accessToken: accessToken)
  }
  
  func deleteAccessToken() {
    try? self.keychain.remove(Keychain.Keys.accessToken)
  }
}
