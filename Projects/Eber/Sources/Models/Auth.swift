//
//  Auth.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct Auth: Encodable {
  var id: String
  var password: String
  let deviceType: String = "ios"
}
