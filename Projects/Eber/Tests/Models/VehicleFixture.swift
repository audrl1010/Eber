//
//  VehicleFixture.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import Foundation
@testable import Eber

enum VehicleFixture {
  static let vehicle1 = Vehicle(
    vehicleIdx: 98,
    description: "vehicle1",
    favorite: false,
    licenseNumber: "99-1102-333",
    capacity: 2
  )
  static let vehicle2 = Vehicle(
    vehicleIdx: 99,
    description: "vehicle2",
    favorite: false,
    licenseNumber: "32-4562-423",
    capacity: 10
  )
}
