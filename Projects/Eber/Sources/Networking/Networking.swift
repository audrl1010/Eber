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
    return URL(string: "http://mcricwiojwfb.cleancitynetworks.com/mobile/v1")!
  }
}

final class Networking: MoyaProvider<MultiTarget> {
  
  init(plugins: [PluginType] = []) {
    let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10
    super.init(session: session, plugins: plugins)
  }
  
  func request(
    _ target: TargetType,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) -> Single<Response> {
    let requestString = "\(target.method) \(target.path) \(String(describing: target.headers)) \(target.task)"
    return self.rx.request(MultiTarget(target))
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
  }
}
