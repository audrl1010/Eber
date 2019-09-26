//
//  VehicleListViewReactor.swift
//  Eber
//
//  Created by myung gi son on 25/09/2019.
//

import Nimble
import Quick
import Stubber

@testable import Eber

class VehicleListViewReactorSpec: QuickSpec {
  
  override func spec() {
    func createReactor(vehicleService: VehicleServiceStub = .init()) -> VehicleListViewReactor {
      let cellReactorFactory = VehicleCellReactor.Factory(
        dependency: .init()
      )
      let factory = VehicleListViewReactor.Factory.init(
        dependency: .init(
          vehicleService: vehicleService,
          alertService: AlertServiceStub(),
          cellReactorFactory: cellReactorFactory
        )
      )
      return factory.create()
    }
    
    var vehicleService: VehicleServiceStub!
    var reactor: VehicleListViewReactor!
    
    beforeEach {
      vehicleService = VehicleServiceStub()
      reactor = createReactor(vehicleService: vehicleService)
    }
    
    describe("an initial state") {
      it("is not loading") {
        expect(reactor.currentState.isLoading) == false
      }
      it("has empty query") {
        expect(reactor.currentState.query) == ""
      }
      it("has empty sections") {
        expect(reactor.currentState.sections).to(beEmpty())
      }
    }

    context("when receives a refresh action") {
      it("fetches vehicles") {
        reactor.action.onNext(.refresh)
        expect(Stubber.executions(vehicleService.vehicles).count) == 1
      }
    }
  }
}
