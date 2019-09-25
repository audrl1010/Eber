//
//  VehicleService.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift

protocol VehicleServiceProtocol {
  func vehicles() -> Single<[Vehicle]>
}

final class VehicleService: VehicleServiceProtocol {
  private let networking: Networking
  
  init(networking: Networking) {
    self.networking = networking
  }
  
  func vehicles() -> Single<[Vehicle]> {
    return self.networking.request(.target(VehicleAPI.vehicles))
      .map([Vehicle].self, atKeyPath: "data")
  }
}
