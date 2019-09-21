//
//  AccessToken.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct AccessToken {
  var accessToken: String
}

extension AccessToken: Codable {
  enum CodingKeys: String, CodingKey {
    case accessToken = "token"
  }
}
