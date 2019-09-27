//
//  ModelType.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

import Then

protocol ModelType: Codable, Then {
  associatedtype Event
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
    return .iso8601
  }
  
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = self.dateDecodingStrategy
    return decoder
  }
}
