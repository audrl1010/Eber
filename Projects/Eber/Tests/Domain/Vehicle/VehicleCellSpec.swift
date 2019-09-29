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
      let factory = VehicleCellReactor.Factory()
      reactor = factory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
      reactor.isStubEnabled = true
      cell = VehicleCell()
      cell.reactor = reactor
    }
    
    it("has subviews") {
      expect(cell.descriptionLabel.superview) === cell.contentView
      expect(cell.capacityLabel.superview) === cell.contentView
      expect(cell.favoriteButton.superview) === cell.contentView
      expect(cell.licenseNumberLabel.superview) === cell.contentView
    }
    
    describe("a favorite button") {
      context("when favorite") {
        it("has favorite image") {
          reactor.stub.state.value.isFavorite = true
          expect(cell.favoriteButton.image(for: .normal)) == R.image.favorite()
        }
      }
      
      context("when unfavorite") {
        it("has unfavorite image") {
          reactor.stub.state.value.isFavorite = false
          expect(cell.favoriteButton.image(for: .normal)) == R.image.unfavorite()
        }
      }
    }
  }
}
