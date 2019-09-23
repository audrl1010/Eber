//
//  Networking.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Moya
import RxSwift

typealias EberNetworking = Networking

extension EberNetworking {
  static var baseURL: URL {
    return URL(string: "https://mcricwiojwfb.cleancitynetworks.com/mobile/v1")!
  }
}

protocol NetworkingProtocol {
  func request(_ target: MultiTarget, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension NetworkingProtocol {
  func request(_ target: MultiTarget, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
    return self.request(target, file: file, function: function, line: line)
  }
}

final class Networking: MoyaProvider<MultiTarget>, NetworkingProtocol {
  
  init(plugins: [PluginType] = []) {
    let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10
    super.init(session: session, plugins: plugins)
  }
  
  func request(
    _ target: MultiTarget,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) -> Single<Response> {
    let requestString = "\(target.method) \(target.path) \(String(describing: target.headers)) \(target.task)"
    return self.rx.request(MultiTarget(target))
      .filterSuccessfulStatusCodes()
      .do(
        onSuccess: { value in
          let message = "SUCCESS: \(requestString) (\(value.statusCode))"
          log.debug(message, file: file, function: function, line: line)
        },
        onError: { error in
          if let response = (error as? MoyaError)?.response {
            if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
              let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
              log.warning(message, file: file, function: function, line: line)
            } else if let rawString = String(data: response.data, encoding: .utf8) {
              let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
              log.warning(message, file: file, function: function, line: line)
            } else {
              let message = "FAILURE: \(requestString) (\(response.statusCode))"
              log.warning(message, file: file, function: function, line: line)
            }
          } else {
            let message = "FAILURE: \(requestString)\n\(error)"
            log.warning(message, file: file, function: function, line: line)
          }
        },
        onSubscribed: {
          let message = "REQUEST: \(requestString)"
          log.debug(message, file: file, function: function, line: line)
        }
      )
      .catchError {
        guard let error = $0 as? MoyaError else {
          return .error(EberClientError.unknown)
        }
        if case let .statusCode(status) = error {
          if status.statusCode == 500 {
            return .error(EberClientError.serverErrorCode500)
          }
          let badRequestResponse = try JSONDecoder().decode(BadRequestResponse.self, from: status.data)
          return .error(EberClientError.badRequest(badRequestResponse))
        }
        guard case let .underlying(value) = error else { return .error(EberClientError.unknown) }
        let nsError = value.0 as NSError
        if nsError.code == 13 {
          return .error(
            EberClientError.notConnectInternet(
              code: String(nsError.code),
              message: nsError.localizedDescription
            )
          )
        }
        return .error(EberClientError.unknown)
      }
  }
}
