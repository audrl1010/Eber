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
    func createCellReactor(vehicle: Vehicle = VehicleFixture.vehicle1) -> VehicleCellReactor {
      let factory = VehicleCellReactor.Factory(
        dependency: .init()
      )
      return factory.create(payload: .init(vehicle: vehicle))
    }
    
    var reactor: VehicleCellReactor!
    var cell: VehicleCell!
    
    beforeEach {
      reactor = createCellReactor(vehicle: VehicleFixture.vehicle1)
      reactor.isStubEnabled = true
      cell = VehicleCell()
      cell.reactor = reactor
    }
    
    it("has subviews") {
      expect(cell.descriptionLabel.superview) === cell.contentView
      expect(cell.capacityLabel.superview) === cell.contentView
      expect(cell.favoriteImageView.superview) === cell.contentView
      expect(cell.licenseNumberLabel.superview) === cell.contentView
    }
  }
}
