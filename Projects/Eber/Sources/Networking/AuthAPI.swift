//
//  AuthAPI.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//


import Moya

enum AuthAPI {
  case authorize(Auth)
}

extension AuthAPI: TargetType {
  
  var baseURL: URL {
    return EberNetworking.baseURL
  }
  
  var path: String {
    switch self {
    case .authorize:
      return "/auth"
    }
  }
  
  var method: Method {
    switch self {
    case .authorize:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case let .authorize(auth):
      return .requestJSONEncodable(auth)
    }
  }
  
  var headers: [String : String]? {
    return ["Accept" : "application/json"]
  }
  
  var sampleData: Data {
    return Data()
  }
}
