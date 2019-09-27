//
//  AuthPlugin.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import Moya

class AuthPlugin: PluginType {
  var authService: AuthServiceProtocol?
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let accessToken = self.authService?.currentAccessToken?.accessToken {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
    }
    return request
  }
}
