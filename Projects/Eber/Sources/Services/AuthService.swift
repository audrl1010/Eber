//
//  AuthService.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift
import KeychainAccess

protocol AuthServiceProtocol {
  var currentAccessToken: AccessToken? { get }
  func authorize(auth: Auth) -> Single<Void>
}
