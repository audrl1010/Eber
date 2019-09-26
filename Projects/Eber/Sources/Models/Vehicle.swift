//
//  Vehicle.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import Foundation

struct Vehicle: Codable {
  var vehicleIdx: Int
  var description: String
  var favorite: Bool
  var licenseNumber: String
  var capacity: Int // L unit
}
