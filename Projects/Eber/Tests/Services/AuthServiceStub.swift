//
//  AuthServiceStub.swift
//  Eber
//
//  Created by myung gi son on 19/09/2019.
//

import RxSwift
import Stubber

@testable import Eber

final class AuthServiceStub: AuthServiceProtocol {
  var currentAccessToken: AccessToken? { return nil }
  
  func authorize(auth: Auth) -> Single<Void> {
    return Stubber.invoke(authorize, args: auth, default: .never())
  }
}
