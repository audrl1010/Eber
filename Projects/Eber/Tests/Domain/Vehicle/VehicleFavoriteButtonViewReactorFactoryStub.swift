//
//  VehicleFavoriteButtonViewReactorFactoryStub.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

@testable import Eber

extension VehicleFavoriteButtonViewReactor.Factory {
  static func stub(
    vehicleService: VehicleServiceProtocol,
    alertService: AlertServiceProtocol
  ) -> VehicleFavoriteButtonViewReactor.Factory {
    return VehicleFavoriteButtonViewReactor.Factory(
      dependency: .init(
        vehicleService: vehicleService,
        alertService: alertService
      )
    )
  }
}
