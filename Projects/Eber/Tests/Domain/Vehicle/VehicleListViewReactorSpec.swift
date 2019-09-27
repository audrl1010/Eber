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
    var vehicleService: VehicleServiceStub!
    var reactor: VehicleListViewReactor!
    var cellReactorFactory: VehicleCellReactor.Factory!
    
    beforeEach {
      vehicleService = VehicleServiceStub()
      let alertService = AlertServiceStub()
      
      let favoriteButtonViewReactorFactory = VehicleFavoriteButtonViewReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService
      )
      cellReactorFactory = VehicleCellReactor.Factory.stub(
        vehicleService: vehicleService,
        alertService: alertService,
        favoriteButtonViewReactorFactory: favoriteButtonViewReactorFactory
      )
      let factory = VehicleListViewReactor.Factory.init(
        dependency: .init(
          vehicleService: vehicleService,
          alertService: alertService,
          cellReactorFactory: cellReactorFactory
        )
      )
      reactor = factory.create()
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
        let vehicles = [VehicleFixture.vehicle1, VehicleFixture.vehicle2]
        Stubber.register(vehicleService.vehicles) { _ in .just(vehicles) }
        reactor.action.onNext(.refresh)
        expect(Stubber.executions(vehicleService.vehicles).count) == 1
        expect(reactor.currentState.sectionItems[0].cellReactor.vehicle.vehicleIdx) === vehicles[0].vehicleIdx
        expect(reactor.currentState.sectionItems[1].cellReactor.vehicle.vehicleIdx) === vehicles[1].vehicleIdx
      }
    }
    
    context("when has fetched vehicle 2") {
      beforeEach {
        let vehicles = [VehicleFixture.vehicle1, VehicleFixture.vehicle2]
        Stubber.register(vehicleService.vehicles) { _ in .just(vehicles) }
        reactor.action.onNext(.refresh)
      }
      
      context("when receives a updateQuery action") {
        it("set query") {
          let query = "vehicle"
          reactor.action.onNext(.updateQuery(query))
          expect(reactor.currentState.query) === query
        }
        context("when has query = '333'") {
          it("has filtered 2 sectionItems") {
            let query = "333"
            reactor.action.onNext(.updateQuery(query))
            expect(reactor.currentState.sections[0].items.count) == 2
          }
        }
        context("when has query = 'vehicle'") {
          it("has filtered 2 sectionItems") {
            let query = "vehicle"
            reactor.action.onNext(.updateQuery(query))
            expect(reactor.currentState.sections[0].items.count) == 2
          }
        }
        context("when has query = '99'") {
          it("has filtered 1 sectionItems") {
            let query = "99"
            reactor.action.onNext(.updateQuery(query))
            expect(reactor.currentState.sections[0].items.count) == 1
          }
        }
      }
    }
    
    describe("state.isLoading") {
      context("while fetching vehicles") {
        it("is loading") {
          Stubber.register(vehicleService.vehicles) { _ in .never() }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isLoading) == true
        }
      }
      
      context("when finished fetching vehicles") {
        it("is not loading") {
          let vehicles = [VehicleFixture.vehicle1, VehicleFixture.vehicle2]
          Stubber.register(vehicleService.vehicles) { _ in .just(vehicles) }
          reactor.action.onNext(.refresh)
          expect(reactor.currentState.isLoading) == false
        }
      }
    }
  }
}
