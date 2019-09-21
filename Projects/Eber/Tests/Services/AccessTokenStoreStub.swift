//
//  AccessTokenStoreStub.swift
//  Eber
//
//  Created by myung gi son on 21/09/2019.
//

import Foundation
import Stubber
@testable import Eber

final class AccessTokenStoreStub: AccessTokenStoreProtocol {
  
  func saveAccessToken(_ accessToken: AccessToken) {
    Stubber.invoke(saveAccessToken, args: accessToken, default: Void())
  }
  
  func loadAccessToken() -> AccessToken? {
    return Stubber.invoke(loadAccessToken, args: (), default: nil)
  }
  
  func deleteAccessToken() {
    Stubber.invoke(deleteAccessToken, args: (), default: Void())
  }
}
