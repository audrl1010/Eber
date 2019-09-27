//
//  Vehicle.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct Vehicle: ModelType {
  enum Event {
    case updateFavorite(vehicleIdx: Int, isFavorite: Bool)
  }
  var vehicleIdx: Int
  var description: String
  var favorite: Bool
  var licenseNumber: String
  var capacity: Int // L unit
}

// Array + Vehicle Extension

extension Vehicle {
  var hashValue: Int {
    return self.vehicleIdx
  }
}

extension Vehicle {
  func isContain(query: String, partialMatchTargets targets: [KeyPath<Self, String>]) -> Bool {
    return targets.filter { target in
      let value = self[keyPath: target].lowercased().removeWhitespace()
      return value.isMatch(of: query.lowercased().removeWhitespace())
    }.count > 0
  }
}

extension Array where Element == Vehicle {
  func search(query: String, partialMatchTargets targets: [KeyPath<Element, String>]) -> [Element] {
    return self.filter { element in
      element.isContain(query: query, partialMatchTargets: targets)
    }
  }
}
