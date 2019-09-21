//
//  NetworkingStub.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Moya
import RxSwift
import Stubber
import Nimble
import Quick

@testable import Eber

final class NetworkingStub: NetworkingProtocol {
  func request(_ target: MultiTarget, file: StaticString, function: StaticString, line: UInt) -> Single<Response> {
    return Stubber.invoke(request, args: (target, file, function, line), default: .error(TestError()))
  }
}
