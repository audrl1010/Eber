//
//  VehicleCellReactorFactoryStub.swift
//  Eber
//
//  Created by myung gi son on 27/09/2019.
//

@testable import Eber

extension VehicleCellReactor.Factory {
  static func stub(
    vehicleService: VehicleServiceProtocol,
    alertService: AlertServiceProtocol,
    favoriteButtonViewReactorFactory: VehicleFavoriteButtonViewReactor.Factory
  ) -> VehicleCellReactor.Factory {
    return VehicleCellReactor.Factory(
      dependency: .init(
        favoriteButtonViewReactorFactory: favoriteButtonViewReactorFactory
      )
    )
  }
}
