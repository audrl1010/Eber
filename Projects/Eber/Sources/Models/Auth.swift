//
//  Auth.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct Auth {
  var id: String
  var password: String
  let deviceType: String = "ios"
}

extension Auth: Codable {
  enum CodingKeys: String, CodingKey {
    case id = "userId"
    case password
    case deviceType
  }
}
