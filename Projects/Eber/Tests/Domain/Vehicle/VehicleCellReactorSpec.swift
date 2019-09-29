//
//  VehicleCellReactorSpec.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import Quick
import Nimble

@testable import Eber

class VehicleCellReactorSpec: QuickSpec {
  
  override func spec() {
    var reactor: VehicleCellReactor!
    
    beforeEach {
      let vehicleService = VehicleServiceStub()
      let alertService = AlertServiceStub()
      let favoriteButtonViewReactorFactory = VehicleFavoriteButtonViewReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService
      )
      let cellReactorFactory = VehicleCellReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService,
        favoriteButtonViewReactorFactory: favoriteButtonViewReactorFactory
      )
      reactor = cellReactorFactory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
    }
    
    describe("state.description") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.description) == VehicleFixture.vehicle1.description
      }
    }
    
    describe("state.favorite") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.isFavorite) == VehicleFixture.vehicle1.favorite
      }
    }
    
    describe("state.licenseNumber") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.licenseNumber) == VehicleFixture.vehicle1.licenseNumber
      }
    }
    
    describe("state.capacity") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.capacity) == String(VehicleFixture.vehicle1.capacity)
      }
    }
  }
}
