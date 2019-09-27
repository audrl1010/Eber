//
//  VehicleService.swift
//  Eber
//
//  Created by myung gi son on 18/09/2019.
//

import RxSwift

protocol VehicleServiceProtocol {
  func vehicles() -> Single<[Vehicle]>
  func favorite(vehicleIdx: Int) -> Single<Void>
  func unfavorite(vehicleIdx: Int) -> Single<Void>
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
  
  func favorite(vehicleIdx: Int) -> Single<Void> {
    Vehicle.event.onNext(.updateFavorite(vehicleIdx: vehicleIdx, isFavorite: true))
    return self.networking.request(.target(VehicleAPI.favorite(vehicleIdx: vehicleIdx)))
      .map { _ in }
      .do(onError: { error in
        Vehicle.event.onNext(.updateFavorite(vehicleIdx: vehicleIdx, isFavorite: false))
      })
  }
  
  func unfavorite(vehicleIdx: Int) -> Single<Void> {
    Vehicle.event.onNext(.updateFavorite(vehicleIdx: vehicleIdx, isFavorite: false))
    return self.networking.request(.target(VehicleAPI.unfavorite(vehicleIdx: vehicleIdx)))
      .map { _ in }
      .do(onError: { error in
        Vehicle.event.onNext(.updateFavorite(vehicleIdx: vehicleIdx, isFavorite: true))
      })
  }
}
