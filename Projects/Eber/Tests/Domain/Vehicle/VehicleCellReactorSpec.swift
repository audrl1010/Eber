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
    func createReactor(vehicleService: VehicleServiceStub = .init()) -> VehicleCellReactor {
      let factory = VehicleCellReactor.Factory.init(dependency: .init())
      return factory.create(payload: .init(vehicle: VehicleFixture.vehicle1))
    }
    
    var reactor: VehicleCellReactor!
    
    beforeEach {
      reactor = createReactor()
    }
    
    describe("state.description") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.description) == VehicleFixture.vehicle1.description
      }
    }
    
    describe("state.favorite") {
      it("is same with the initialized parameter value") {
        expect(reactor.currentState.favorite) == VehicleFixture.vehicle1.favorite
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
