//
//  AuthPlugin.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import Moya

struct AuthPlugin: PluginType {
  private let accessTokenStore: AccessTokenStoreProtocol
  
  init(accessTokenStore: AccessTokenStoreProtocol) {
    self.accessTokenStore = accessTokenStore
  }
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let accessToken = self.accessTokenStore.loadAccessToken()?.accessToken {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
    }
    return request
  }
}
