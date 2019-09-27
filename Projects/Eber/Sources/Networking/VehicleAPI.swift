//
//  VehicleAPI.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Moya

enum VehicleAPI {
  case vehicles
  case favorite(vehicleIdx: Int)
  case unfavorite(vehicleIdx: Int)
}

extension VehicleAPI: TargetType {
  
  var baseURL: URL {
    return EberNetworking.baseURL
  }
  
  var path: String {
    switch self {
    case .vehicles:
      return "/users/self/vehicles"
      
    case let .favorite(vehicleIdx):
      return "/users/self/vehicles/\(vehicleIdx)/favorite"
    
    case let .unfavorite(vehicleIdx):
      return "/users/self/vehicles/\(vehicleIdx)/favorite"
    }
  }
  
  var method: Method {
    switch self {
    case .vehicles:
      return .get
      
    case .favorite:
      return .put
      
    case .unfavorite:
      return .put
    }
  }
  
  var task: Task {
    switch self {
    case .vehicles:
      return .requestPlain
      
    case .favorite:
      return .requestParameters(
        parameters: ["status": true],
        encoding: URLEncoding(boolEncoding: .literal)
      )
      
    case .unfavorite:
      return .requestParameters(
        parameters: ["status": false],
        encoding: URLEncoding(boolEncoding: .literal)
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
