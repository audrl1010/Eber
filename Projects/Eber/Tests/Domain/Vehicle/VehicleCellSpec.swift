//
//  VehicleCellSpec.swift
//  Eber
//
//  Created by myung gi son on 26/09/2019.
//

import Nimble
import Quick
@testable import Eber

final class VehicleCellSpec: QuickSpec {
  override func spec() {
    var reactor: VehicleCellReactor!
    var cell: VehicleCell!
    
    beforeEach {
      let vehicleService = VehicleServiceStub()
      let alertService = AlertServiceStub()
      
      let buttonViewReactorFactory = VehicleFavoriteButtonViewReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService
      )
      let factory = VehicleCellReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService,
        favoriteButtonViewReactorFactory: buttonViewReactorFactory
      )
      reactor = factory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
      reactor.isStubEnabled = true
      cell = VehicleCell()
      cell.reactor = reactor
    }
    
    it("has subviews") {
      expect(cell.descriptionLabel.superview) === cell.contentView
      expect(cell.capacityLabel.superview) === cell.contentView
      expect(cell.favoriteButtonView.superview) === cell.contentView
      expect(cell.licenseNumberLabel.superview) === cell.contentView
    }
  }
}
