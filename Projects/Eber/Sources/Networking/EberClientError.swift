//
//  EberClientError.swift
//  Eber
//
//  Created by myung gi son on 22/09/2019.
//

import Moya
import RxSwift

protocol EberErrorType: Error {
  var message: String? { get }
}

enum EberClientError {
  case unknown
  case notConnectInternet(code: String, message: String)
  case badRequest(BadRequestResponse)
  case serverErrorCode500
}

extension EberClientError: EberErrorType {
  var message: String? {
    switch self {
    case .unknown:
      return "알 수 없는 에러 발생"
    case .notConnectInternet:
      return "인터넷 연결이 불안정합니다."
    case .serverErrorCode500:
      return "내부 서버 에러 발생"
    case .badRequest(let badRequestResponse):
      return badRequestResponse.message
    }
  }
}

struct BadRequestResponse: Decodable {
  var statusCode: Int
  var error: String
  var message: String
}
