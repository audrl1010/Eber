//
//  AuthAPI.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//


import Moya

enum UserAPI {
  case signIn(userId: String, password: String)
}

extension UserAPI: TargetType {
  
  var baseURL: URL {
    return EberNetworking.baseURL
  }
  
  var path: String {
    switch self {
    case .signIn:
      return "/auth"
    }
  }
  
  var method: Method {
    switch self {
    case .signIn:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case let .signIn(userId, password):
      return .requestParameters(
        parameters: [
          "userrId": userId,
          "password": password,
          "deviceType": "ios"
        ],
        encoding: URLEncoding.default
      )
    }
  }
  
  var headers: [String : String]? {
    return ["Accept" : "application/json"]
  }
  
  var sampleData: Data {
    return Data()
  }
}
